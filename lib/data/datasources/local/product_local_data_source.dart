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
    log(
      'getAllProducts:'
      'from ${ProductTable.name} -> ${jsonEncode(rows)}',
      name: 'DB-READ',
    );
    return rows.map(ProductModel.fromMap).toList(growable: false);
  }

  Future<ProductModel?> getProductById(String id) async {
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

  Future<ProductModel?> getProductByIdInTxn(Transaction txn, String id) async {
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
    String productId,
  ) async {
    final db = await _db;
    final rows = await db.query(
      ProductTransactionTable.name,
      where: '${ProductTransactionTable.productId} = ?',
      whereArgs: [productId],
      orderBy: '${ProductTransactionTable.createdAt} DESC',
    );
    log(
      'getTransactionsForProduct: '
      '${jsonEncode(rows)}',
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

  Future<void> insertProductInTxn(Transaction txn, ProductModel product) async {
    await txn.insert(
      ProductTable.name,
      product.toMap(),
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

  Future<void> deleteProduct(String id) async {
    final db = await _db;
    await db.delete(
      ProductTable.name,
      where: '${ProductTable.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertTransactionInTxn(
    Transaction txn,
    ProductTransactionModel transaction,
  ) async {
    await txn.insert(
      ProductTransactionTable.name,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<void> markTransactionsSynced(List<String> ids) async {
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
}
