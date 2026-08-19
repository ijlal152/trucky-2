# Transaction Ordering, Optional Payment, and True In-Place Edit

**Date:** 2026-08-19
**Status:** Approved (Approach 1)
**Scope:** Single implementation plan

## Problem

Three related defects in the client/supplier + product transaction flows:

1. **Ordering regression (Payment before Sale).** When a sale is recorded, the
   client/supplier dashboard can list the settlement `Payment` row before the
   `Sale` row even though the database records them Sale-first (same
   `transaction_id`, same `txn_data`). The user reports this was fixed before
   but "is coming again."
2. **Payment is optional.** Recording a Sale/Purchase/Return always creates a
   settlement `Payment`/`Refund` row, even when the payment amount is 0 or
   empty. When no payment is entered, no settlement row should be persisted.
3. **Editing a Sale records a new sale.** `SalePurchasePersistence
   .editTransaction` deletes the client/supplier rows, hides (but does not
   delete) the old product-ledger rows, then calls `addTransaction`, which
   mints a **new** `transaction_id`. Net effect: a brand-new Sale appears in
   the ledger, the old product rows remain in the DB, and stock is
   double-deducted. The product dashboard shows duplicated/stale rows instead
   of the edited values.

## Root causes (verified)

### Ordering

- The DB recording order is correct: `addTransaction`
  (`lib/presentation/sales_purchases/sale_purchase_persistence.dart:99-107`)
  inserts the main txn (Sale) first, then the settlement (Payment).
- The **display** bug is in `ClientSuppBloc._sortTxnsNewestFirst`
  (`lib/presentation/client_supplier/bloc/client_supp_bloc.dart:422-434`).
  Commit `6747a2a` added the timestamp tie-break comparator in the **wrong
  direction**:
  `_paymentTypePriority(b).compareTo(_paymentTypePriority(a))` — which places
  Payment (priority 1) before Sale (priority 0).
- The working tree **already contains the correct comparator**:
  `_paymentTypePriority(a).compareTo(_paymentTypePriority(b))` (line 429-431),
  and the bloc test `sale sorts before its payment when timestamps tie`
  passes. The fix is simply **uncommitted** — hence "it comes again" when the
  app is rebuilt from the committed state.

### Payment optional

- `addTransaction` unconditionally dispatches the settlement txn
  (`sale_purchase_persistence.dart:105-107`) regardless of
  `data.paymentAmount`.

### Edit records a new sale

- `editTransaction` (`sale_purchase_persistence.dart:111-132`):
  1. `RemoveTransactionsEvent` — hard-deletes the client/supplier txn rows.
  2. `RemoveProductDetailsEvent` — **only hides** rows from the current view
     (`product_bloc.dart:353-365`, "append-only by design"); ledger rows stay
     in the DB.
  3. `addTransaction(...)` — mints a fresh `transaction_id` and inserts a new
     Sale + settlement + new product rows.
- Result: duplicate product rows, double stock deduction, and the edited sale
  appears as a new record.

## Decisions (confirmed with user)

1. **Edit semantics:** **true edit, update in place, same `transactionId`**.
   Replace old rows (client/supplier + product ledger) with corrected rows
   under the original `transactionId`.
2. **Payment optional:** **skip the settlement row entirely** when the
   payment/refund amount is 0 (empty field).
3. **Edit approach:** **Approach 1 — delete-by-transactionId + re-insert +
   ledger replay** for stock/WAC correctness.
4. **Edit timestamp:** **preserve the original `txnData`** — the edited
   transaction stays at its original position in the ledger; balances and
   history do not shift.

## Architecture

### 1. Ordering — keep working-tree comparator (no new code)

- `ClientSuppBloc._sortTxnsNewestFirst` already has the correct
  `a.compareTo(b)` tie-break in the working tree.
- Action: retain it and include it in the implementation commit.
- `SalePurchaseState.salePurchaseTxns`
  (`client_supp_state.dart:62-71`) only filters Sale/Return rows and needs no
  tie-break (no Payment rows present).

### 2. Optional payment — gate the settlement row

- `addTransaction`: only dispatch `_buildSettlementTxn(...)` when
  `data.paymentAmount > 0`.
- Edit mode: when payment drops to 0, the settlement row is deleted (via the
  same delete-by-transactionId path) and not re-added.

### 3. True in-place edit (Approach 1: replay)

#### 3a. Client/supplier data layer
- **No new method needed.** The existing `RemoveTransactionsEvent` →
  `_onRemoveTransactions` (`client_supp_bloc.dart:355-389`) already deletes
  every row sharing the `transactionId` (Sale + Payment) via the per-row
  `_deleteClientSuppTxn(t.id!)` path. Reuse it as-is.

#### 3b. Product data layer
- Add `ProductLocalDataSource.deleteTransactionsByTransactionId(String
  transactionId)`: batch `DELETE FROM product_transactions_table WHERE
  transaction_id = ?`. This is the first real product-ledger delete (the
  current `RemoveProductDetailsEvent` only hides rows from the view).

#### 3c. Product repository — snapshot rebuild (WAC replay)
- Add `ProductRepository.rebuildSnapshotsForProducts(List<int> productIds)`:
  - For each product, read its full ledger chronologically
    (`getTransactionsForProduct` asc).
  - Fold through `CalculateWac` starting from `(oldQuantity: 0,
    oldAverageCost: 0)`:
    - `initialStock`/`purchase` rows → `WacOp.purchase`
    - `sale` rows → `WacOp.sale`
    - `returned` rows → `WacOp.returned`
  - Write the final `stockQuantity`/`stockValue`/`averageCost` back to the
    product snapshot.
  - Runs inside a DB transaction per product (or one transaction across all).

#### 3d. Persistence orchestration — `editTransaction`
- New flow:
  1. Capture `oldTxn.txnData` (preserve original timestamp).
  2. Delete client/supplier rows by `transactionId` (existing
     `RemoveTransactionsEvent`).
  3. Delete product rows by `transactionId` (new real delete, replacing the
     view-hide — new `DeleteProductDetailsEvent` or repurposed handler).
  4. Re-insert the corrected Sale + optional Payment + product rows **under
     the same `transactionId`**, with the **original `txnData`**.
  5. `rebuildSnapshotsForProducts(affectedIds)`.
- `addTransaction` unchanged besides the optional-payment gate.

## Changes by file

1. `lib/data/datasources/local/product_local_data_source.dart`
   — add `deleteTransactionsByTransactionId`.
2. `lib/data/repositories/product_repository_impl.dart`
   — implement `rebuildSnapshotsForProducts` (ledger replay) +
   `deleteTransactionsByTransactionId` bridge.
3. `lib/domain/repositories/product_repository.dart`
   — add `rebuildSnapshotsForProducts(List<int> productIds)` (and the delete
   bridge if the repo owns deletes).
4. `lib/presentation/sales_purchases/sale_purchase_persistence.dart`
   — gate settlement on `paymentAmount > 0`; rewrite `editTransaction` for
   same-transactionId replace + replay + original txnData.
5. `lib/presentation/products/bloc/product_bloc.dart`
   — repurpose `_onRemoveProductDetails` (currently view-hide only) to perform
   a real delete by `transactionId` + `rebuildSnapshotsForProducts` for the
   affected products. Event name/arity unchanged (only dispatched from
   `editTransaction`).
6. `lib/presentation/client_supplier/bloc/client_supp_bloc.dart`
   — keep working-tree comparator (no change; verify).

## Data flow (edit)

1. Dashboard / Sales list tap → `TransactionEditMixin.onTapToEdit`.
2. Sale/Return/Purchase → cart edit → payment screen → validate →
   `editTransaction`.
3. `editTransaction` deletes old client/supplier rows + old product rows,
   re-inserts corrected Sale + optional Payment + product rows (same
   `transactionId`, original `txnData`), then rebuilds affected product
   snapshots via ledger replay.
4. Client/supplier dashboard re-renders from `ClientSuppBloc` state
   (`_onRemoveTransactions` + `_onAddTransaction` keep `selectedCSTxns` in
   sync, Sale before Payment via the fixed comparator).
5. Product dashboard reads the replayed ledger: edited rows, no duplicates,
   correct stock/WAC.

## Error handling

- Replay may surface `InsufficientStockFailure`/`StateError` if the ledger is
  inconsistent; surface via existing `Result` + snackbar path.
- Deletes and re-inserts happen through the existing bloc events so snackbar
  handling stays in one place.

## Testing

- **Ordering:** existing `client_supp_bloc_test.dart` tie-break test (already
  passing in working tree) — keep.
- **Optional payment:** new test that a Sale with `paymentAmount == 0` does
  not create a Payment settlement row.
- **Edit in place:**
  - `test/presentation/products/screens/product_dashboard_screen_test.dart`:
    editing a sale updates the shown product transaction rows (edited
    quantity/price replace the old rows), no duplicate rows, stock reflects
    the edit.
  - `client_supp_bloc_test.dart`: after edit, no new Sale row; same
    `transactionId`; original `txnData` preserved.
- **Fakes:** update `test/helpers/fake_product_repository.dart` for the new
  product repository methods (`deleteTransactionsByTransactionId`,
  `rebuildSnapshotsForProducts`). No new client/supplier repo methods, so
  `fake_client_supp_repository.dart` is unchanged.
- **Persistence tests:** `sale_purchase_bloc_test.dart` exercises
  `addTransaction`/`editTransaction`; verify the optional-payment gate and the
  same-transactionId edit against the fake blocs/repos.

## Out of scope

- Barcode scanner / add-product-from-cart.
- Editing `Initial Balance`.
- Sync/audit of edited rows (rows are re-inserted with a new row id under the
  same `transactionId`; the append-only audit contract for non-edited
  transactions is unchanged).