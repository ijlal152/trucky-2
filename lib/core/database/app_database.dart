import 'dart:developer';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:trucky/core/database/table_names.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const int schemaVersion = 1;

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

  /// Apply incremental migrations. Currently no migrations are needed beyond
  /// version 1; future versions add their steps here in order.
  Future<void> _migrate(Database db, int oldVersion) async {
    if (oldVersion < 2) {
      // Example migration for the next schema bump.
    }
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
