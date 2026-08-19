import 'dart:convert';
import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:trucky/core/database/app_database.dart';
import 'package:trucky/core/database/product_table.dart';
import 'package:trucky/core/database/product_transaction_table.dart';
import 'package:trucky/core/errors/exceptions.dart';
import 'package:trucky/data/models/product_model.dart';
import 'package:trucky/data/models/product_transaction_model.dart';

class ProductLocalDataSource {
  ProductLocalDataSource({AppDatabase? database})
    : _appDatabase = database ?? AppDatabase.instance;

  final AppDatabase _appDatabase;

  Future<Database> get _db async => _appDatabase.database;

  // ---------------- Reads ----------------

  Future<List<ProductModel>> getAllProducts() async {
    final db = await _db;
    final rows = await db.query(
      ProductTable.name,
      orderBy: '${ProductTable.createdAt} ASC',
    );
    log('Product Table:\n${jsonEncode(rows)}');
    return rows.map(ProductModel.fromMap).toList(growable: false);
  }

  Future<ProductModel?> getProductById(int id) async {
    final db = await _db;
    final rows = await db.query(
      ProductTable.name,
      where: '${ProductTable.id} = ?',
      whereArgs: [id],
      limit: 1,
    );
    log(
      'getProductById:'
      '-> ${jsonEncode(rows)}',
      name: 'DB-READ',
    );
    if (rows.isEmpty) return null;
    return ProductModel.fromMap(rows.first);
  }

  Future<ProductModel?> getProductByIdInTxn(Transaction txn, int id) async {
    final rows = await txn.query(
      ProductTable.name,
      where: '${ProductTable.id} = ?',
      whereArgs: [id],
      limit: 1,
    );
    log(
      'getProductByIdInTxn: read ${rows.length} row(s) for id=$id '
      '-> ${jsonEncode(rows)}',
      name: 'DB-READ',
    );
    if (rows.isEmpty) return null;
    return ProductModel.fromMap(rows.first);
  }

  Future<List<ProductTransactionModel>> getTransactionsForProduct(
    int productId,
  ) async {
    final db = await _db;
    final rows = await db.query(
      ProductTransactionTable.name,
      where: '${ProductTransactionTable.productId} = ?',
      whereArgs: [productId],
      orderBy: '${ProductTransactionTable.createdAt} DESC',
    );
    log('Product Transaction Table -> \n${jsonEncode(rows)}');
    return rows.map(ProductTransactionModel.fromMap).toList(growable: false);
  }

  /// Every ledger row across all products, oldest first. Used to join a
  /// transaction's products back from the database by `transaction_id`.
  Future<List<ProductTransactionModel>> getAllProductTransactions() async {
    final db = await _db;
    final rows = await db.query(
      ProductTransactionTable.name,
      orderBy: '${ProductTransactionTable.createdAt} ASC',
    );
    log(
      'getAllProductTransactions: '
      '-> ${jsonEncode(rows)}',
      name: 'DB-READ',
    );
    return rows.map(ProductTransactionModel.fromMap).toList(growable: false);
  }

  Future<List<ProductTransactionModel>> getUnsyncedTransactions({
    int limit = 500,
  }) async {
    final db = await _db;
    final rows = await db.query(
      ProductTransactionTable.name,
      where: '${ProductTransactionTable.isSynced} = 0',
      orderBy: '${ProductTransactionTable.createdAt} ASC',
      limit: limit,
    );
    log(
      'getUnsyncedTransactions: '
      '-> ${jsonEncode(rows)}',
      name: 'DB-READ',
    );
    return rows.map(ProductTransactionModel.fromMap).toList(growable: false);
  }

  // ---------------- Writes ----------------

  Future<int> insertProductInTxn(Transaction txn, ProductModel product) async {
    final map = product.toMap()..remove(ProductTable.id);
    return txn.insert(
      ProductTable.name,
      map,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> updateProductSnapshotInTxn(
    Transaction txn,
    ProductModel product,
  ) async {
    final updated = await txn.update(
      ProductTable.name,
      product.toMap(),
      where: '${ProductTable.id} = ?',
      whereArgs: [product.id],
    );
    if (updated == 0) {
      throw CacheException(
        'Failed to update product snapshot for id=${product.id}',
      );
    }
  }

  Future<void> deleteProduct(int id) async {
    final db = await _db;
    await db.delete(
      ProductTable.name,
      where: '${ProductTable.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertTransactionInTxn(
    Transaction txn,
    ProductTransactionModel transaction,
  ) async {
    final map = transaction.toMap()..remove(ProductTransactionTable.id);
    return txn.insert(
      ProductTransactionTable.name,
      map,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> markTransactionsSynced(List<int> ids) async {
    if (ids.isEmpty) return;
    final db = await _db;
    final placeholders = List.filled(ids.length, '?').join(', ');
    await db.rawUpdate(
      'UPDATE ${ProductTransactionTable.name} '
      'SET ${ProductTransactionTable.isSynced} = 1 '
      'WHERE ${ProductTransactionTable.id} IN ($placeholders)',
      ids,
    );
  }

  /// Deletes every ledger row for [transactionId]. Returns the distinct
  /// product ids whose rows were removed so their snapshots can be rebuilt.
  Future<List<int>> deleteTransactionsByTransactionIdInTxn(
    Transaction txn,
    String transactionId,
  ) async {
    final rows = await txn.query(
      ProductTransactionTable.name,
      columns: [ProductTransactionTable.productId],
      where: '${ProductTransactionTable.transactionId} = ?',
      whereArgs: [transactionId],
    );
    final productIds = rows
        .map((r) => r[ProductTransactionTable.productId] as int)
        .toSet()
        .toList();
    await txn.delete(
      ProductTransactionTable.name,
      where: '${ProductTransactionTable.transactionId} = ?',
      whereArgs: [transactionId],
    );
    return productIds;
  }

  /// Returns a product's ledger rows, oldest first, for snapshot replay.
  Future<List<ProductTransactionModel>> getTransactionsForProductInTxn(
    Transaction txn,
    int productId,
  ) async {
    final rows = await txn.query(
      ProductTransactionTable.name,
      where: '${ProductTransactionTable.productId} = ?',
      whereArgs: [productId],
      orderBy: '${ProductTransactionTable.createdAt} ASC',
    );
    return rows.map(ProductTransactionModel.fromMap).toList(growable: false);
  }
}
