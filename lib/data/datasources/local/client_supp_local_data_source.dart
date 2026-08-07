import 'dart:convert';
import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:trucky/core/database/app_database.dart';
import 'package:trucky/core/database/client_supp_table.dart';
import 'package:trucky/core/database/client_supp_txn_table.dart';
import 'package:trucky/data/models/client_supp_model.dart';
import 'package:trucky/data/models/client_supp_txn_model.dart';

/// Local (SQLite) data source for clients & suppliers.
class ClientSuppLocalDataSource {
  ClientSuppLocalDataSource({AppDatabase? database})
    : _appDatabase = database ?? AppDatabase.instance;

  final AppDatabase _appDatabase;

  Future<Database> get _db async => _appDatabase.database;

  // ---------------- Reads ----------------

  Future<List<ClientSuppModel>> fetchAllClientSupps() async {
    final db = await _db;
    final rows = await db.query(ClientSuppTable.name);
    log('ClientSupp Table:\n${jsonEncode(rows)}');
    return rows.map(ClientSuppModel.fromMap).toList(growable: false);
  }

  Future<List<ClientSuppTxnModel>> fetchAllClientSuppTxns() async {
    final db = await _db;
    final rows = await db.query(ClientSuppTxnTable.name);

    // return mockTransactions.map(ClientSuppTxnModel.fromMap).toList(growable: false);
    log('ClientSupp Transaction Table:\n${jsonEncode(rows)}');
    return rows.map(ClientSuppTxnModel.fromMap).toList(growable: false);
  }

  // ---------------- Writes ----------------

  Future<int> insertClientSupp(ClientSuppModel model) async {
    final db = await _db;
    return db.insert(
      ClientSuppTable.name,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> updateClientSupp(ClientSuppModel model) async {
    final db = await _db;
    return db.update(
      ClientSuppTable.name,
      model.toMap(),
      where: '${ClientSuppTable.id} = ?',
      whereArgs: [model.id],
    );
  }

  Future<int> deleteClientSupp(int id) async {
    final db = await _db;
    return db.delete(
      ClientSuppTable.name,
      where: '${ClientSuppTable.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertClientSuppTxn(ClientSuppTxnModel model) async {
    final db = await _db;
    return db.insert(
      ClientSuppTxnTable.name,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> deleteClientSuppTxn(int txnId) async {
    final db = await _db;
    return db.delete(
      ClientSuppTxnTable.name,
      where: '${ClientSuppTxnTable.id} = ?',
      whereArgs: [txnId],
    );
  }
}

var mockTransactions = [
  {
    "id": 1,
    "user_id": 1,
    "client_supp_id": 1,
    "transaction_id": "txn-1786104552867179",
    "client_supplier_name": "Client 1",
    "role": "client",
    "txn_data": 1786104552867,
    "discount_amount": "0",
    "amount": "55000",
    "payment_type": "Initial Balance",
    "note": null,
    "is_synced": 0,
  },
  {
    "id": 1,
    "user_id": 1,
    "client_supp_id": 1,
    "transaction_id": "txn-1786104552867174",
    "client_supplier_name": "Client 1",
    "role": "client",
    "txn_data": 1786104556666,
    "discount_amount": "0",
    "amount": "10000",
    "payment_type": "Sale",
    "note": null,
    "is_synced": 0,
  },
  {
    "id": 1,
    "user_id": 1,
    "client_supp_id": 1,
    "transaction_id": "txn-1786104552867174",
    "client_supplier_name": "Client 1",
    "role": "client",
    "txn_data": 1786104557777,
    "discount_amount": "0",
    "amount": "5000",
    "payment_type": "Payment",
    "note": null,
    "is_synced": 0,
  },
  {
    "id": 1,
    "user_id": 1,
    "client_supp_id": 1,
    "transaction_id": "txn-1786104552867174",
    "client_supplier_name": "Client 1",
    "role": "client",
    "txn_data": 1786104558888,
    "discount_amount": "0",
    "amount": "5000",
    "payment_type": "Return",
    "note": null,
    "is_synced": 0,
  },
  {
    "id": 1,
    "user_id": 1,
    "client_supp_id": 1,
    "transaction_id": "txn-1786104552867174",
    "client_supplier_name": "Client 1",
    "role": "client",
    "txn_data": 1786104559999,
    "discount_amount": "0",
    "amount": "5000",
    "payment_type": "Refund",
    "note": null,
    "is_synced": 0,
  },
];
