import 'dart:developer';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:trucky/core/database/table_names.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const int schemaVersion = 5;

  Database? _database;

  Future<Database> get database async {
    final existing = _database;
    if (existing != null) return existing;
    final opened = await _open();
    _database = opened;
    if (opened.isOpen) {
      log('Database opened successfully.');
    } else {
      log('Failed to open the database.');
    }
    return opened;
  }

  Future<Database> _open() async {
    final databasesPath = await getDatabasesPath();
    return openDatabase(
      p.join(databasesPath, 'trucky.db'),
      version: schemaVersion,
      onCreate: (db, version) async {
        await _createSchema(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await _migrate(db, oldVersion);
      },
    );
  }

  Future<void> _createSchema(Database db) async {
    await _createClientSuppTables(db);
    await _createProductTables(db);
  }

  Future<void> _createClientSuppTables(Database db) async {
    await db.execute('''
      CREATE TABLE ${TableNames.clientSuppTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        role TEXT NOT NULL,
        phone_number TEXT,
        gps_location TEXT,
        is_synced INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE ${TableNames.clientSuppTransactionsTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        client_supp_id INTEGER NOT NULL,
        transaction_id TEXT NOT NULL,
        client_supplier_name TEXT NOT NULL,
        role TEXT NOT NULL,
        txn_data INTEGER NOT NULL,
        discount_amount TEXT NOT NULL DEFAULT '0',
        amount TEXT NOT NULL,
        payment_type TEXT NOT NULL,
        note TEXT,
        is_synced INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (client_supp_id) REFERENCES ${TableNames.clientSuppTable} (id)
          ON DELETE CASCADE
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_txn_client_supp_id '
      'ON ${TableNames.clientSuppTransactionsTable} (client_supp_id)',
    );
  }

  Future<void> _createProductTables(Database db) async {
    // products_table: cached snapshot of inventory aggregates.
    await db.execute('''
      CREATE TABLE ${TableNames.productsTable} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        sku TEXT NOT NULL UNIQUE,
        selling_price REAL NOT NULL DEFAULT 0,
        stock_quantity INTEGER NOT NULL DEFAULT 0,
        stock_value REAL NOT NULL DEFAULT 0,
        average_cost REAL NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // product_transactions_table: append-only ledger (source of truth).
    await db.execute('''
      CREATE TABLE ${TableNames.productTransactionTable} (
        id TEXT PRIMARY KEY,
        product_id TEXT NOT NULL,
        type TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        total_price REAL NOT NULL,
        created_at INTEGER NOT NULL,
        is_synced INTEGER NOT NULL DEFAULT 0,
        source_name TEXT,
        source_type TEXT,
        FOREIGN KEY (product_id) REFERENCES ${TableNames.productsTable} (id)
          ON DELETE CASCADE
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_product_txn_product_id '
      'ON ${TableNames.productTransactionTable} (product_id)',
    );
    await db.execute(
      'CREATE INDEX idx_product_txn_is_synced '
      'ON ${TableNames.productTransactionTable} (is_synced)',
    );
  }

  /// Apply incremental migrations.
  Future<void> _migrate(Database db, int oldVersion) async {
    if (oldVersion < 2) {
      await _migrateToV2(db);
    }
    if (oldVersion < 3) {
      await _migrateToV3(db);
    }
    if (oldVersion < 4) {
      await _migrateToV4(db);
    }
    if (oldVersion < 5) {
      await _migrateToV5(db);
    }
  }

  Future<void> _migrateToV2(Database db) async {
    await db.execute(
      'ALTER TABLE ${TableNames.clientSuppTable} '
      'ADD COLUMN user_id INTEGER NOT NULL DEFAULT 0',
    );
    await db.execute(
      'ALTER TABLE ${TableNames.clientSuppTable} '
      'ADD COLUMN is_synced INTEGER NOT NULL DEFAULT 0',
    );
    await db.execute(
      'ALTER TABLE ${TableNames.clientSuppTransactionsTable} '
      'ADD COLUMN user_id INTEGER NOT NULL DEFAULT 0',
    );
    await db.execute(
      'ALTER TABLE ${TableNames.clientSuppTransactionsTable} '
      'ADD COLUMN discount_amount TEXT NOT NULL DEFAULT \'0\'',
    );
    await db.execute(
      'ALTER TABLE ${TableNames.clientSuppTransactionsTable} '
      'ADD COLUMN is_synced INTEGER NOT NULL DEFAULT 0',
    );
    await _createProductTables(db);
  }

  /// v3: replace the legacy product tables with the inventory snapshot +
  /// append-only ledger schema (WAC, stock_value, type-based transactions).
  Future<void> _migrateToV3(Database db) async {
    await db.execute(
      'DROP TABLE IF EXISTS ${TableNames.productTransactionTable}',
    );
    await db.execute('DROP TABLE IF EXISTS ${TableNames.productsTable}');
    await _createProductTables(db);
  }

  /// v4: quantity and stock_quantity are whole units, so store them as
  /// INTEGER rather than REAL (matching the int-typed models).
  Future<void> _migrateToV4(Database db) async {
    await db.execute(
      'DROP TABLE IF EXISTS ${TableNames.productTransactionTable}',
    );
    await db.execute('DROP TABLE IF EXISTS ${TableNames.productsTable}');
    await _createProductTables(db);
  }

  /// v5: add the client/supplier counterparty to the inventory ledger so the
  /// products section can show who a sale/purchase/return came from.
  Future<void> _migrateToV5(Database db) async {
    await db.execute(
      'ALTER TABLE ${TableNames.productTransactionTable} '
      'ADD COLUMN source_name TEXT',
    );
    await db.execute(
      'ALTER TABLE ${TableNames.productTransactionTable} '
      'ADD COLUMN source_type TEXT',
    );
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
