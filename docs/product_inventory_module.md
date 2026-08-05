# Product & Inventory Module — Technical Documentation

> **Audience:** Mid-to-senior Flutter developers maintaining or extending the Trucky POS app.
> **Scope:** The `products` + `product_transactions` schema, Weighted Average Cost (WAC) logic, offline-first sync strategy, and Dart model contracts.
> **Status:** Production-ready reference. Treat the SQL schema and Dart models as the contract; changes here ripple through the BLoCs, repositories, and the sync service.

---

## Table of Contents

1. [Overview & Design Goals](#1-overview--design-goals)
2. [Database Design](#2-database-design)
3. [Product Table (Cached Snapshot)](#3-product-table-cached-snapshot)
4. [Product Transaction Table (Source of Truth)](#4-product-transaction-table-source-of-truth)
5. [Weighted Average Cost (WAC) Logic](#5-weighted-average-cost-wac-logic)
6. [Offline-First Sync Strategy](#6-offline-first-sync-strategy)
7. [Data Flow — End-to-End](#7-data-flow--end-to-end)
8. [Flutter Model Structure](#8-flutter-model-structure)
9. [Design Principles](#9-design-principles)
10. [Performance Considerations](#10-performance-considerations)
11. [Edge Cases & Failure Modes](#11-edge-cases--failure-modes)
12. [Implementation Checklist](#12-implementation-checklist)

---

## 1. Overview & Design Goals

Trucky is a **local-first POS app** used in environments where connectivity is unreliable (e.g., truck drivers selling goods on routes). Multiple devices may operate offline for hours or days and reconcile later when a network becomes available.

### Core requirements

| #   | Requirement                                     | How we satisfy it                                               |
| --- | ----------------------------------------------- | --------------------------------------------------------------- |
| 1   | Fully offline operation                         | All reads/writes go to local SQLite (`sqflite`).                |
| 2   | Sync via a flag, **never** via server IDs       | Transactions carry an `is_synced` boolean only.                 |
| 3   | Transactions are the **single source of truth** | Inventory state is derivable from the transactions log.         |
| 4   | Product table is a **cached snapshot**          | Pre-computed aggregates (stock, value, WAC) for fast UI.        |
| 5   | Weighted Average Cost (WAC) supported           | Recomputed locally on every purchase, persisted on the product. |

### Non-goals (intentionally out of scope)

- No `server_id` columns. The local UUID is the only identity.
- No client/supplier tables in this module — they live in their own module.
- No codegen (no `freezed`, no `build_runner`). Plain Dart classes with manual `copyWith`.

---

## 2. Database Design

We deliberately ship **exactly two tables** for this module:

```
┌──────────────────────────────┐         ┌───────────────────────────────────┐
│   products_table            │         │   product_transactions_table       │
│   (snapshot / cache)         │ 1   N  │   (source of truth / audit log)   │
│                              │─────────│                                   │
└──────────────────────────────┘         └───────────────────────────────────┘
```

Both tables are managed by the `AppDatabase` singleton. Schema lives in `lib/core/database/`.

```sql
-- products_table: cached aggregates, one row per SKU.
CREATE TABLE products_table (
  id              TEXT    PRIMARY KEY,           -- local UUID v4
  name            TEXT    NOT NULL,
  sku             TEXT    NOT NULL UNIQUE,
  selling_price   REAL    NOT NULL,              -- retail price
  stock_quantity  REAL    NOT NULL DEFAULT 0,    -- current on-hand
  stock_value     REAL    NOT NULL DEFAULT 0,    -- stock_quantity * average_cost
  average_cost    REAL    NOT NULL DEFAULT 0,    -- Weighted Average Cost
  created_at      INTEGER NOT NULL,              -- epoch millis (UTC)
  updated_at      INTEGER NOT NULL               -- epoch millis (UTC)
);

-- product_transactions_table: append-only ledger.
CREATE TABLE product_transactions_table (
  id            TEXT    PRIMARY KEY,             -- local UUID v4
  product_id    TEXT    NOT NULL,               -- FK -> products_table.id
  type          TEXT    NOT NULL,               -- 'purchase' | 'sale' | 'return'
  quantity      REAL    NOT NULL,               -- signed: +in / -out semantics per type
  unit_price    REAL    NOT NULL,               -- price at the moment of the txn
  total_price   REAL    NOT NULL,               -- quantity * unit_price
  created_at    INTEGER NOT NULL,               -- epoch millis (UTC)
  is_synced     INTEGER NOT NULL DEFAULT 0,     -- 0 = pending, 1 = acknowledged
  FOREIGN KEY (product_id) REFERENCES products_table(id)
);

CREATE INDEX idx_ptx_product_id      ON product_transactions_table(product_id);
CREATE INDEX idx_ptx_is_synced       ON product_transactions_table(is_synced);
CREATE INDEX idx_ptx_created_at      ON product_transactions_table(created_at);
```

> **Note on quantities.** `quantity` is stored as a **positive magnitude**. Sign semantics are derived from `type` (see §5). This avoids sign-handling bugs in the UI.

---

## 3. Product Table (Cached Snapshot)

### Fields

| Field            | Type      | Purpose                                                   |
| ---------------- | --------- | --------------------------------------------------------- |
| `id`             | `TEXT`    | Local UUID — the only identity for this row.              |
| `name`           | `TEXT`    | Display name shown in the catalog.                        |
| `sku`            | `TEXT`    | Stock-Keeping Unit; unique, scannable, indexed.           |
| `selling_price`  | `REAL`    | Retail price. Independent of `average_cost`.              |
| `stock_quantity` | `REAL`    | Current available stock. **Snapshot, not authoritative.** |
| `stock_value`    | `REAL`    | `stock_quantity * average_cost`. Total inventory value.   |
| `average_cost`   | `REAL`    | WAC. Recomputed only on PURCHASE.                         |
| `created_at`     | `INTEGER` | Epoch millis when the product was created.                |
| `updated_at`     | `INTEGER` | Epoch millis of the last transaction touching this row.   |

### Why store `stock_value`?

`stock_value` is the answer to "what is my inventory worth right now?" — a question the dashboard asks on every cold start.

Without it, we would have to either:

1. Sum `quantity * average_cost` over a join across the transaction log for every product on every render — **O(N × M)** and unusable above a few hundred SKUs.
2. Trust the UI to multiply `stock_quantity * average_cost` at display time — fragile if either field is loaded lazily or partial.

Persisting it makes the dashboard a single indexed read:

```sql
SELECT id, name, stock_quantity, stock_value, average_cost FROM products_table;
```

### Why store `average_cost` instead of recalculating every time?

WAC requires **every purchase in the product's history** to be replayed. For a 12-month-old SKU with 200 purchases, that is 200 rows joined and summed on every report, cart preview, or profit-margin widget. Doing this on every render is unacceptable.

Instead, we **eagerly update** `average_cost` inside the same SQLite transaction that appends the new `purchase` transaction. After that, reads are O(1).

The original transactions are still preserved — so we can always re-derive the snapshot from the ledger if a corruption or migration requires it.

---

## 4. Product Transaction Table (Source of Truth)

### Fields

| Field         | Type      | Purpose                                                              |
| ------------- | --------- | -------------------------------------------------------------------- |
| `id`          | `TEXT`    | Local UUID — identity for sync. **Never** a server-issued ID.        |
| `product_id`  | `TEXT`    | FK to `products_table.id`. Indexed.                                  |
| `type`        | `TEXT`    | `'purchase'` \| `'sale'` \| `'return'`. Enum enforced in Dart layer. |
| `quantity`    | `REAL`    | Positive magnitude. Direction is encoded by `type`.                  |
| `unit_price`  | `REAL`    | Price at the moment of the transaction.                              |
| `total_price` | `REAL`    | `quantity * unit_price`. Stored to avoid rounding drift in reports.  |
| `created_at`  | `INTEGER` | Epoch millis — also drives sync conflict resolution.                 |
| `is_synced`   | `INTEGER` | `0` = pending upload, `1` = acknowledged by backend.                 |

### Why transactions are the source of truth

- **Auditability.** Every unit that entered or left stock is recorded with a price and a timestamp.
- **Reproducibility.** The snapshot can always be rebuilt from the ledger — corruption, schema migration, or a wrong write is recoverable.
- **Sync granularity.** Each transaction is an independent syncable unit; partial sync failures don't lose data.
- **Reporting.** Period reports (purchases per supplier, sales per day) are simple `SUM()` aggregations.

### Why `is_synced` is enough

The local UUID is the global identity. The backend, when it accepts a transaction, only needs to remember the client-generated `id` so it can dedupe if the same row arrives twice (e.g., the device reconnects after the first upload silently succeeded).

No `server_id` is stored locally because:

- It would create **two identities** for the same row, breaking offline references.
- It leaks sync state into the domain model.
- It complicates conflict resolution — clients should not need to "know" which server they talked to.

The sync protocol is therefore:

```
client → POST /transactions  body: [{id, product_id, type, quantity, ...}]
server → 200 OK
client → UPDATE product_transactions_table SET is_synced = 1 WHERE id IN (...)
```

---

## 5. Weighted Average Cost (WAC) Logic

WAC is the per-unit cost of inventory after each purchase. Sales and returns do **not** change the average cost — they change quantity and total value only.

### 5.1 PURCHASE

Receiving new stock at a different supplier price blends the old and new costs:

$$
\text{new\_avg} = \frac{(\text{old\_qty} \times \text{old\_avg}) + (\text{purchased\_qty} \times \text{purchase\_price})}{\text{old\_qty} + \text{purchased\_qty}}
$$

```dart
final newQty    = oldQty + purchasedQty;
final newAvg    = newQty == 0
    ? purchasePrice
    : ((oldQty * oldAvg) + (purchasedQty * purchasePrice)) / newQty;
final newValue  = newQty * newAvg;
```

**Example**

| Step | old_qty | old_avg | purchased_qty | purchase_price | new_qty | new_avg |
| ---- | ------- | ------- | ------------- | -------------- | ------- | ------- |
| 1    | 0       | 0       | 10            | 8.00           | 10      | 8.00    |
| 2    | 10      | 8.00    | 10            | 10.00          | 20      | 9.00    |
| 3    | 20      | 9.00    | 5             | 12.00          | 25      | 9.60    |

Step 2 in detail: `(10×8.00 + 10×10.00) / (10 + 10) = 180 / 20 = 9.00`.

### 5.2 SALE

Selling stock does **not** change `average_cost`. It reduces `stock_quantity` and `stock_value`:

```dart
final newQty   = oldQty - soldQty;            // assert newQty >= 0 (see §11)
final newValue = newQty * oldAvg;             // average_cost unchanged
```

`average_cost` stays identical so future sales and profit calculations remain correct.

### 5.3 RETURN

A return is a transaction with `type = 'return'`. The `unit_price` and the current `average_cost` together tell us **what kind of return** it is:

| Scenario            | unit_price vs average_cost    | Effect on stock_quantity | Effect on average_cost | Effect on stock_value  |
| ------------------- | ----------------------------- | ------------------------ | ---------------------- | ---------------------- |
| **Purchase return** | `unit_price == average_cost`  | `+` returned qty         | **unchanged**          | `+ qty × average_cost` |
| **Sale return**     | `unit_price == selling_price` | `+` returned qty         | **unchanged**          | `+ qty × average_cost` |

In both cases, returning goods to stock **adds quantity back** at the current `average_cost`. We do **not** "rewind" history to the original purchase price — that would violate the WAC invariant.

```dart
// Pseudo-code executed inside the same SQLite txn as the insert:
final product = readProduct(productId);
final newQty  = product.stockQuantity + returnedQty;
final newVal  = newQty * product.averageCost;     // average_cost unchanged
updateProduct(productId, stockQuantity: newQty, stockValue: newVal, updatedAt: now);
```

If a `return` is effectively a **sale return** that should refund the customer at `selling_price`, that pricing decision is handled at the order/invoice layer — the inventory module only sees `quantity` going back into stock.

---

## 6. Offline-First Sync Strategy

### 6.1 Local write path

Every business action — purchase, sale, return — runs **fully inside a SQLite transaction**:

```dart
await db.transaction((txn) async {
  final txnId = uuid.v4();

  // 1) Append the immutable transaction record (is_synced = 0).
  txn.insert('product_transactions_table', {
    'id': txnId,
    'product_id': productId,
    'type': type.name,
    'quantity': qty,
    'unit_price': unitPrice,
    'total_price': qty * unitPrice,
    'created_at': now,
    'is_synced': 0,
  });

  // 2) Recompute and persist the snapshot.
  final product = _read(txn, productId);
  final newQty   = _nextQuantity(product, type, qty);
  final newAvg   = _nextAverageCost(product, type, qty, unitPrice);
  final newValue = newQty * newAvg;
  txn.update(
    'products_table',
    {
      'stock_quantity': newQty,
      'stock_value': newValue,
      'average_cost': newAvg,
      'updated_at': now,
    },
    where: 'id = ?',
    whereArgs: [productId],
  );
});
```

The snapshot can always be rebuilt from the log, so even if step 2 partially fails inside the same SQLite transaction, both writes roll back atomically.

### 6.2 Sync process

When connectivity returns, the sync service runs:

```dart
Future<void> syncPendingTransactions() async {
  final pending = await db.query(
    'product_transactions_table',
    where: 'is_synced = 0',
    orderBy: 'created_at ASC',
    limit: 500,
  );
  if (pending.isEmpty) return;

  try {
    await api.postTransactions(pending);          // idempotent by client id
    await db.transaction((txn) async {
      for (final row in pending) {
        txn.update(
          'product_transactions_table',
          {'is_synced': 1},
          where: 'id = ?',
          whereArgs: [row['id']],
        );
      }
    });
  } on NetworkException {
    // leave is_synced = 0, retry on next connectivity event
  } on ServerException catch (e) {
    // server rejected this batch -> quarantine, surface to operator
  }
}
```

Because the local UUID is the identity, the backend **must** dedupe by `id`. Re-posting the same batch (e.g., after a flaky network) is safe.

### 6.3 Conflict handling

Conflicts can arise when **two devices** both created transactions for the same SKU while offline, then both sync.

**Strategy: last-write-wins by `created_at` timestamp, applied per-device on the server.**

Why timestamps suffice:

- The local device clock is the only clock the device trusts.
- Transactions are append-only — there is nothing to "merge" on the client.
- The server is the merge point: it accepts each transaction in the order each device submits them, recomputes the snapshot server-side using the same WAC formula, and stores the resulting snapshot per device.

**Why order matters:**

WAC is order-sensitive. If two devices both receive a shipment at different prices while offline, the order in which the server applies them changes the resulting `average_cost`. To make this deterministic:

- Each device tags its transactions with its own monotonic `created_at`.
- The server processes devices in a stable order (e.g., `device_id ASC`) and within a device by `created_at ASC`.
- The resulting `average_cost` is the same regardless of network arrival order.

The client does **not** try to resolve conflicts — that is a server concern. The client only ensures its local log is consistent and forwardable.

---

## 7. Data Flow — End-to-End

### 7.1 Purchase flow

```
┌────────────────────────┐
│ User submits a purchase │
└───────────┬────────────┘
            │
            ▼
   ┌────────────────────┐
   │ ProductBloc          │
   │ emits AddPurchase()  │
   └───────────┬─────────┘
               │  use case: RecordPurchase(productId, qty, price)
               ▼
   ┌────────────────────────────────────────────────┐
   │ ProductRepository.recordPurchase(...)           │
   │   db.transaction((txn) async { ... })           │
   │                                                │
   │  1. INSERT product_transactions_table           │
   │     type='purchase', is_synced=0                │
   │                                                │
   │  2. UPDATE products_table                       │
   │     stock_quantity, stock_value, average_cost   │
   │     using WAC formula                           │
   └───────────┬────────────────────────────────────┘
               │
               ▼
   ┌────────────────────┐
   │ Emits new state      │
   │ (loaded + snapshot)  │
   └────────────────────┘
```

### 7.2 Sale flow

```
┌────────────────────────┐
│ Cart confirmed, sale     │
│ submitted                │
└───────────┬────────────┘
            │
            ▼
   ┌──────────────────────────────────────────┐
   │ For each cart line:                       │
   │   db.transaction((txn) async {            │
   │     1. INSERT product_transactions_table  │
   │        type='sale', is_synced=0           │
   │                                          │
   │     2. UPDATE products_table              │
   │        stock_quantity -= qty              │
   │        stock_value = qty * average_cost   │
   │        average_cost UNCHANGED             │
   │   })                                      │
   └──────────────────────────────────────────┘
```

### 7.3 Return flow

```
┌────────────────────────┐
│ User records a return   │
│ (purchase or sale)      │
└───────────┬────────────┘
            │
            ▼
   ┌──────────────────────────────────────────────────┐
   │ db.transaction((txn) async {                      │
   │   1. INSERT product_transactions_table            │
   │      type='return', is_synced=0                   │
   │                                                  │
   │   2. UPDATE products_table                        │
   │      stock_quantity += returnedQty                │
   │      stock_value = newQty * average_cost          │
   │      average_cost UNCHANGED                       │
   │ })                                                │
   └──────────────────────────────────────────────────┘
```

In every flow:

1. The transaction row is **inserted first** (immutable, append-only).
2. The product snapshot is **updated second** using the WAC formula.
3. Both happen inside one SQLite transaction → atomic, crash-safe.

---

## 8. Flutter Model Structure

Models are plain Dart classes — no codegen, no `freezed`. They live under `lib/data/models/` and are mapped to/from `Map<String, Object?>` for SQLite.

### 8.1 `ProductModel`

```dart
import 'package:trucky/core/database/product_table.dart';

class ProductModel {
  final String  id;
  final String  name;
  final String  sku;
  final double  sellingPrice;
  final double  stockQuantity;
  final double  stockValue;
  final double  averageCost;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.sellingPrice,
    required this.stockQuantity,
    required this.stockValue,
    required this.averageCost,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Construct from a sqflite row.
  factory ProductModel.fromMap(Map<String, Object?> map) {
    return ProductModel(
      id:            map[ProductTable.id]            as String,
      name:          map[ProductTable.productName]   as String,
      sku:           map[ProductTable.productSku]    as String,
      sellingPrice:  (map[ProductTable.sellingPrice]  as num).toDouble(),
      stockQuantity: (map[ProductTable.stockQuantity] as num).toDouble(),
      stockValue:    (map[ProductTable.stockValue]    as num).toDouble(),
      averageCost:   (map[ProductTable.averageCost]   as num).toDouble(),
      createdAt:     DateTime.fromMillisecondsSinceEpoch(
                       map[ProductTable.createdAt] as int),
      updatedAt:     DateTime.fromMillisecondsSinceEpoch(
                       map[ProductTable.updatedAt] as int),
    );
  }

  /// Serialize for sqflite.
  Map<String, Object?> toMap() => {
        ProductTable.id:            id,
        ProductTable.productName:   name,
        ProductTable.productSku:    sku,
        ProductTable.sellingPrice:  sellingPrice,
        ProductTable.stockQuantity: stockQuantity,
        ProductTable.stockValue:    stockValue,
        ProductTable.averageCost:   averageCost,
        ProductTable.createdAt:     createdAt.millisecondsSinceEpoch,
        ProductTable.updatedAt:     updatedAt.millisecondsSinceEpoch,
      };

  ProductModel copyWith({
    String?   id,
    String?   name,
    String?   sku,
    double?   sellingPrice,
    double?   stockQuantity,
    double?   stockValue,
    double?   averageCost,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id:            id            ?? this.id,
      name:          name          ?? this.name,
      sku:           sku           ?? this.sku,
      sellingPrice:  sellingPrice  ?? this.sellingPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      stockValue:    stockValue    ?? this.stockValue,
      averageCost:   averageCost   ?? this.averageCost,
      createdAt:     createdAt     ?? this.createdAt,
      updatedAt:     updatedAt     ?? this.updatedAt,
    );
  }
}
```

### 8.2 `ProductTransactionModel`

```dart
import 'package:trucky/core/database/product_transaction_table.dart';

enum ProductTransactionType { purchase, sale, return }

class ProductTransactionModel {
  final String                  id;
  final String                  productId;
  final ProductTransactionType  type;
  final double                  quantity;     // positive magnitude
  final double                  unitPrice;
  final double                  totalPrice;
  final DateTime                createdAt;
  final bool                    isSynced;

  const ProductTransactionModel({
    required this.id,
    required this.productId,
    required this.type,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.createdAt,
    required this.isSynced,
  });

  factory ProductTransactionModel.fromMap(Map<String, Object?> map) {
    return ProductTransactionModel(
      id:         map[ProductTransactionTable.id]         as String,
      productId:  map[ProductTransactionTable.productId]  as String,
      type:       _typeFromString(
                    map[ProductTransactionTable.type]     as String),
      quantity:   (map[ProductTransactionTable.quantity]   as num).toDouble(),
      unitPrice:  (map[ProductTransactionTable.unitPrice]  as num).toDouble(),
      totalPrice: (map[ProductTransactionTable.totalPrice] as num).toDouble(),
      createdAt:  DateTime.fromMillisecondsSinceEpoch(
                    map[ProductTransactionTable.createdAt] as int),
      isSynced:   (map[ProductTransactionTable.isSynced] as int) == 1,
    );
  }

  Map<String, Object?> toMap() => {
        ProductTransactionTable.id:         id,
        ProductTransactionTable.productId:  productId,
        ProductTransactionTable.type:       type.name,
        ProductTransactionTable.quantity:   quantity,
        ProductTransactionTable.unitPrice:  unitPrice,
        ProductTransactionTable.totalPrice: totalPrice,
        ProductTransactionTable.createdAt:  createdAt.millisecondsSinceEpoch,
        ProductTransactionTable.isSynced:   isSynced ? 1 : 0,
      };

  static ProductTransactionType _typeFromString(String raw) {
    return ProductTransactionType.values.firstWhere(
      (t) => t.name == raw,
      orElse: () =>
          throw FormatException('Unknown transaction type: $raw'),
    );
  }
}
```

> **`total_price` vs `quantity * unit_price`.** We store `total_price` because floating-point rounding across thousands of transactions accumulates drift that breaks reports. Always recompute it at write time and trust the stored value at read time.

---

## 9. Design Principles

### Why the Product table is a snapshot/cache

- **Reads must be O(1).** The home screen, cart, and dashboards query products on every frame. Aggregating from the transaction log on every render is prohibitively expensive.
- **Write amplification is bounded.** The snapshot is updated in the **same transaction** as the insert, so consistency is free — at the cost of one extra `UPDATE` per write.
- **The snapshot is replaceable.** Because the ledger is preserved, a corrupted snapshot is recoverable. The snapshot is purely a read optimization.

### Why transactions must never be deleted

- They are the **audit log** — required for legal/financial reporting.
- They are the **sync units** — the server cannot accept a delete it never saw.
- They are the **recovery source** — if the snapshot is wrong, we replay the log.

The only sanctioned maintenance is a hard-rebuild from the log during a migration.

### Why calculations should not rely only on UI/frontend recomputation

- The UI is a thin renderer; business rules belong in the data/domain layer.
- Multiple entry points (BLoC, background sync worker, deep link) all need the same WAC formula.
- Frontend recomputation couples reading code to writing code — refactoring either becomes risky.

The single source of truth for WAC is a function in `lib/domain/usecases/calculate_wac.dart`, called from the repository inside the SQLite transaction.

---

## 10. Performance Considerations

| Concern                           | Mitigation                                                                                                |
| --------------------------------- | --------------------------------------------------------------------------------------------------------- |
| Full-history scan for stock value | Persist `stock_value` on the snapshot. Update atomically with the txn.                                    |
| Full-history scan for WAC         | Persist `average_cost` on the snapshot. Recompute only on PURCHASE.                                       |
| Listing thousands of products     | Index `sku`; paginate via `LIMIT/OFFSET`; consider FTS for name search.                                   |
| Sync upload size                  | Sync in batches (e.g., 500 rows), ordered by `created_at ASC`.                                            |
| Sync read index                   | Composite index on `(is_synced, created_at)` so the next batch is cheap.                                  |
| Database growth                   | Transactions are append-only — schedule a periodic VACUUM and a snapshot rebuild in a maintenance window. |
| Hot joins                         | Avoid `JOIN product_transactions` in the hot path; rely on the snapshot.                                  |

Rule of thumb: **if a query needs every transaction for a product, it is a report query, not a UI query.** Move it to a dedicated reporting path with explicit caching.

---

## 11. Edge Cases & Failure Modes

### 11.1 Selling more than stock

**Policy:** hard-stop with a user-facing error.

```dart
if (product.stockQuantity < soldQty) {
  throw InsufficientStockException(productId, product.stockQuantity, soldQty);
}
```

This is enforced **before** opening the SQLite transaction. We never write a negative `stock_quantity`.

### 11.2 Negative stock

Negative `stock_quantity` is a **bug**, not a feature. The repository layer asserts it before each write. If the invariant ever breaks (e.g., a partial sync on a corrupted snapshot), a self-healing job can replay the ledger to recompute the snapshot. We log and alert; we do not silently allow it.

### 11.3 Returns after long offline usage

A truck driver may sell 50 units offline, then return 5 units days later — before any sync.

- The local `average_cost` at return time is the correct one (it has already absorbed all purchases up to that point).
- Returning 5 units adds 5 back at the **current** average_cost, exactly as if the sales had never happened from a WAC perspective.
- On sync, the server replays the same transactions in the same order and arrives at the same snapshot. No special handling is required.

### 11.4 Sync conflicts

Conflicts are **resolved server-side** by `created_at` order. The client is responsible only for:

- Sending a deterministic batch (ordered by `created_at ASC`).
- Trusting the server's snapshot if the device ever re-fetches.
- Never assuming the local snapshot matches the server's; on full re-sync, the server snapshot wins and replaces the local one.

### 11.5 Partial sync failure

If a batch upload fails halfway:

- The rows that the server acknowledged are flipped to `is_synced = 1` locally.
- The remaining rows stay at `is_synced = 0` and are retried on the next sync cycle.
- Because the backend dedupes by `id`, retrying is safe.

### 11.6 Clock skew between devices

`created_at` is the local wall clock of the device that **created** the transaction. Two devices in different timezones are not directly comparable — and that is fine: the server orders transactions per `device_id` (each device is its own stream). Cross-device ordering is only required for analytics, not for snapshot correctness, because the snapshot is per-device.

---

## 12. Implementation Checklist

When implementing or reviewing this module, confirm each box:

- [ ] Two tables exist: `products_table`, `product_transactions_table`.
- [ ] No `server_id` column anywhere in this module.
- [ ] `is_synced` is the only sync state field on transactions.
- [ ] Every product write happens **inside a SQLite transaction** with the matching insert.
- [ ] WAC is recomputed **only on PURCHASE**; never on SALE or RETURN.
- [ ] `average_cost` and `stock_value` are persisted on the product snapshot.
- [ ] Insufficient-stock check happens **before** opening the transaction.
- [ ] The sync service processes rows in `created_at ASC` order and dedupes by `id`.
- [ ] `ProductModel` and `ProductTransactionModel` have `fromMap` / `toMap` matching the column constants.
- [ ] No `freezed`, no `build_runner` — plain Dart classes only.
- [ ] `flutter analyze` passes cleanly with zero warnings on touched files.

---

_End of document._
