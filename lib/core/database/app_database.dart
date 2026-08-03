import 'dart:developer';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:trucky/core/database/table_names.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const int schemaVersion = 2;

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
    await db.execute('''
      CREATE TABLE ${TableNames.productsTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        product_name TEXT,
        product_sku TEXT,
        purchase_price TEXT,
        selling_price TEXT,
        quantity_per_package TEXT,
        product_image TEXT,
        is_synced INTEGER NOT NULL DEFAULT 0,
        created_at INTEGER NOT NULL,
        updated_at INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE ${TableNames.productTransactionTable} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        source_id INTEGER,
        source_name TEXT,
        transaction_id TEXT NOT NULL,
        source_type TEXT,
        purchase_price TEXT NOT NULL DEFAULT '0',
        selling_price TEXT NOT NULL DEFAULT '0',
        quantity TEXT NOT NULL DEFAULT '0',
        quantity_per_package TEXT,
        payment_type TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        is_synced INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (product_id) REFERENCES ${TableNames.productsTable} (id)
          ON DELETE CASCADE
      )
    ''');
    await db.execute(
      'CREATE INDEX idx_product_txn_product_id '
      'ON ${TableNames.productTransactionTable} (product_id)',
    );
  }

  /// Apply incremental migrations.
  Future<void> _migrate(Database db, int oldVersion) async {
    if (oldVersion < 2) {
      await _migrateToV2(db);
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

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
