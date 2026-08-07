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
    final rows = await db.query(
      ClientSuppTable.name,
      orderBy: '${ClientSuppTable.createdAt} ASC',
    );
    return rows.map(ClientSuppModel.fromMap).toList(growable: false);
  }

  Future<List<ClientSuppTxnModel>> fetchAllClientSuppTxns() async {
    final db = await _db;
    final rows = await db.query(
      ClientSuppTxnTable.name,
      orderBy: '${ClientSuppTxnTable.txnData} ASC',
    );
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
