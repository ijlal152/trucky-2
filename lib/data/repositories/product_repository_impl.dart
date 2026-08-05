import 'package:sqflite/sqflite.dart';
import 'package:trucky/core/database/app_database.dart';
import 'package:trucky/core/errors/failures.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/data/datasources/local/product_local_data_source.dart';
import 'package:trucky/data/models/product_model.dart';
import 'package:trucky/data/models/product_transaction_model.dart';
import 'package:trucky/domain/entities/product_entity.dart';
import 'package:trucky/domain/entities/product_transaction_entity.dart';
import 'package:trucky/domain/entities/product_transaction_type.dart';
import 'package:trucky/domain/repositories/product_repository.dart';
import 'package:trucky/domain/usecases/calculate_wac.dart';
import 'package:uuid/uuid.dart';

/// Concrete inventory repository.
///
/// Every write runs in a single SQLite transaction that:
///   1. appends the immutable transaction row (`is_synced = 0`), and
///   2. recomputes and persists the snapshot aggregates (WAC, stock_value).
///
/// All failures are returned as [Result.failure]; exceptions never leak.
class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({
    required ProductLocalDataSource local,
    CalculateWac? wac,
    AppDatabase? database,
    Uuid? uuid,
  })  : _local = local,
        _wac = wac ?? const CalculateWac(),
        _appDatabase = database ?? AppDatabase.instance,
        _uuid = uuid ?? const Uuid();

  final ProductLocalDataSource _local;
  final CalculateWac _wac;
  final AppDatabase _appDatabase;
  final Uuid _uuid;

  Future<Database> get _db async => _appDatabase.database;

  // ---------------- Queries ----------------

  @override
  Future<Result<List<ProductEntity>>> getAllProducts() async {
    try {
      final rows = await _local.getAllProducts();
      return Result.success(rows.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<ProductEntity?>> getProductById(String id) async {
    try {
      final row = await _local.getProductById(id);
      return Result.success(row?.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<ProductTransactionEntity>>> getTransactionsForProduct(
    String productId,
  ) async {
    try {
      final rows = await _local.getTransactionsForProduct(productId);
      return Result.success(rows.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<ProductTransactionEntity>>> getUnsyncedTransactions({
    int limit = 500,
  }) async {
    try {
      final rows = await _local.getUnsyncedTransactions(limit: limit);
      return Result.success(rows.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> markTransactionsSynced(List<String> ids) async {
    try {
      await _local.markTransactionsSynced(ids);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteProduct(String id) async {
    try {
      await _local.deleteProduct(id);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  // ---------------- Writes ----------------

  @override
  Future<Result<ProductEntity>> createProduct({
    required String name,
    required String sku,
    required double sellingPrice,
    required double initialQuantity,
    required double initialPurchasePrice,
  }) {
    return _runWrite((txn) async {
      final now = DateTime.now();
      final productId = _uuid.v4();

      // Initial opening purchase transaction (snapshot of opening inventory).
      final openingQty = initialQuantity < 0 ? 0.0 : initialQuantity;
      final openingPrice =
          initialPurchasePrice < 0 ? 0.0 : initialPurchasePrice;
      final openingTotal = openingQty * openingPrice;

      final openingTxn = ProductTransactionModel(
        id: _uuid.v4(),
        productId: productId,
        type: ProductTransactionType.purchase,
        quantity: openingQty,
        unitPrice: openingPrice,
        totalPrice: openingTotal,
        createdAt: now,
        isSynced: false,
      );
      await _local.insertTransactionInTxn(txn, openingTxn);

      final product = ProductModel(
        id: productId,
        name: name,
        sku: sku,
        sellingPrice: sellingPrice,
        stockQuantity: openingQty,
        stockValue: openingTotal,
        averageCost: openingPrice,
        createdAt: now,
        updatedAt: now,
      );
      await _local.insertProductInTxn(txn, product);
      return product.toEntity();
    });
  }

  @override
  Future<Result<ProductEntity>> recordPurchase({
    required String productId,
    required double quantity,
    required double unitPrice,
  }) {
    return _runWrite<ProductEntity>((txn) async {
      final current = await _local.getProductByIdInTxn(txn, productId);
      if (current == null) {
        throw _NotFoundFailure(productId);
      }
      final next = _wac.call(
        oldQuantity: current.stockQuantity,
        oldAverageCost: current.averageCost,
        transactionQuantity: quantity,
        transactionUnitPrice: unitPrice,
        op: WacOp.purchase,
      );
      final now = DateTime.now();
      final updated = current.copyWith(
        stockQuantity: next.newQuantity,
        stockValue: next.newStockValue,
        averageCost: next.newAverageCost,
        updatedAt: now,
      );
      await _insertTxn(
        txn,
        productId: productId,
        type: ProductTransactionType.purchase,
        quantity: quantity,
        unitPrice: unitPrice,
        now: now,
      );
      await _local.updateProductSnapshotInTxn(txn, updated);
      return updated.toEntity();
    });
  }

  @override
  Future<Result<ProductEntity>> recordSale({
    required String productId,
    required double quantity,
    required double unitPrice,
  }) {
    return _runWrite<ProductEntity>((txn) async {
      final current = await _local.getProductByIdInTxn(txn, productId);
      if (current == null) {
        throw _NotFoundFailure(productId);
      }
      if (current.stockQuantity < quantity) {
        throw InsufficientStockFailure(
          productId: productId,
          available: current.stockQuantity,
          requested: quantity,
        );
      }
      final next = _wac.call(
        oldQuantity: current.stockQuantity,
        oldAverageCost: current.averageCost,
        transactionQuantity: quantity,
        transactionUnitPrice: unitPrice,
        op: WacOp.sale,
      );
      final now = DateTime.now();
      final updated = current.copyWith(
        stockQuantity: next.newQuantity,
        stockValue: next.newStockValue,
        // average_cost is intentionally unchanged for sales.
        updatedAt: now,
      );
      await _insertTxn(
        txn,
        productId: productId,
        type: ProductTransactionType.sale,
        quantity: quantity,
        unitPrice: unitPrice,
        now: now,
      );
      await _local.updateProductSnapshotInTxn(txn, updated);
      return updated.toEntity();
    });
  }

  @override
  Future<Result<ProductEntity>> recordReturn({
    required String productId,
    required double quantity,
    required double unitPrice,
  }) {
    return _runWrite<ProductEntity>((txn) async {
      final current = await _local.getProductByIdInTxn(txn, productId);
      if (current == null) {
        throw _NotFoundFailure(productId);
      }
      final next = _wac.call(
        oldQuantity: current.stockQuantity,
        oldAverageCost: current.averageCost,
        transactionQuantity: quantity,
        transactionUnitPrice: unitPrice,
        op: WacOp.returned,
      );
      final now = DateTime.now();
      final updated = current.copyWith(
        stockQuantity: next.newQuantity,
        stockValue: next.newStockValue,
        // average_cost is intentionally unchanged for returns.
        updatedAt: now,
      );
      await _insertTxn(
        txn,
        productId: productId,
        type: ProductTransactionType.returned,
        quantity: quantity,
        unitPrice: unitPrice,
        now: now,
      );
      await _local.updateProductSnapshotInTxn(txn, updated);
      return updated.toEntity();
    });
  }

  // ---------------- Internals ----------------

  Future<Result<T>> _runWrite<T>(
    Future<T> Function(Transaction txn) block,
  ) async {
    final db = await _db;
    try {
      final result = await db.transaction<T>((txn) async {
        return block(txn);
      });
      return Result.success(result);
    } on InsufficientStockFailure catch (f) {
      return Result.failure(f);
    } on _NotFoundFailure catch (f) {
      return Result.failure(f.failure);
    } catch (e) {
      return Result.failure(CacheFailure(e.toString()));
    }
  }

  Future<void> _insertTxn(
    Transaction txn, {
    required String productId,
    required ProductTransactionType type,
    required double quantity,
    required double unitPrice,
    required DateTime now,
  }) async {
    await _local.insertTransactionInTxn(
      txn,
      ProductTransactionModel(
        id: _uuid.v4(),
        productId: productId,
        type: type,
        quantity: quantity,
        unitPrice: unitPrice,
        totalPrice: quantity * unitPrice,
        createdAt: now,
        isSynced: false,
      ),
    );
  }
}

/// Sentinel thrown inside the txn to surface missing-product errors.
class _NotFoundFailure implements Exception {
  _NotFoundFailure(this.productId);

  final String productId;

  AppFailure get failure =>
      CacheFailure('Product not found: $productId');
}
