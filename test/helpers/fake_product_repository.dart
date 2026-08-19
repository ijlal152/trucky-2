import 'package:trucky/core/errors/failures.dart';
import 'package:trucky/core/utils/result.dart';
import 'package:trucky/domain/entities/product_entity.dart';
import 'package:trucky/domain/entities/product_transaction_entity.dart';
import 'package:trucky/domain/entities/product_transaction_type.dart';
import 'package:trucky/domain/repositories/product_repository.dart';
import 'package:trucky/domain/usecases/calculate_wac.dart';
import 'package:trucky/domain/usecases/create_product_usecase.dart';
import 'package:trucky/domain/usecases/delete_product_usecase.dart';
import 'package:trucky/domain/usecases/delete_transactions_by_transaction_id_usecase.dart';
import 'package:trucky/domain/usecases/get_all_products_usecase.dart';
import 'package:trucky/domain/usecases/get_product_transactions_usecase.dart';
import 'package:trucky/domain/usecases/rebuild_snapshots_for_products_usecase.dart';
import 'package:trucky/domain/usecases/record_purchase_usecase.dart';
import 'package:trucky/domain/usecases/record_return_usecase.dart';
import 'package:trucky/domain/usecases/record_sale_usecase.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';

/// In-memory [ProductRepository] that seeds the same sample inventory the old
/// mock bloc used, so product widget/bloc tests keep passing without a real
/// DB.
///
/// The snapshot aggregates are kept in sync with an in-memory ledger using the
/// same [CalculateWac] math as the real repository.
class FakeProductRepository implements ProductRepository {
  FakeProductRepository() {
    _seed();
  }

  final List<ProductEntity> _products = [];
  final Map<int, List<ProductTransactionEntity>> _ledgers = {};
  final CalculateWac _wac = const CalculateWac();
  int _nextProductId = 1;
  int _nextTxnId = 1;

  /// Seeded products mirror the old mock data. `stockValue` is
  /// `stockQuantity * averageCost` so the loaded total stock value is
  /// 4500 + 2400 + 1980 + 2310 + 1800 = 12990.
  void _seed() {
    final now = DateTime.now();
    void add(String name, String sku, int qty, double cost) {
      final id = _nextProductId++;
      _products.add(
        ProductEntity(
          id: id,
          name: name,
          sku: sku,
          sellingPrice: cost * 1.5,
          stockQuantity: qty,
          stockValue: qty * cost,
          averageCost: cost,
          createdAt: now,
          updatedAt: now,
        ),
      );
      _ledgers[id] = [
        ProductTransactionEntity(
          id: _nextTxnId++,
          productId: id,
          type: ProductTransactionType.initialStock,
          quantity: qty,
          unitPrice: cost,
          totalPrice: qty * cost,
          createdAt: now,
          isSynced: true,
        ),
      ];
    }

    add('Engine Oil', 'ENG-001', 100, 45.0);
    add('Brake Pads', 'BRK-001', 60, 40.0);
    add('Air Filter', 'AIR-001', 90, 22.0);
    add('Tires', 'TIR-001', 42, 55.0);
    add('Battery', 'BAT-001', 150, 12.0);
  }

  @override
  Future<Result<List<ProductEntity>>> getAllProducts() async {
    return Result.success(List.of(_products));
  }

  @override
  Future<Result<ProductEntity?>> getProductById(int id) async {
    return Result.success(_byId(id));
  }

  @override
  Future<Result<ProductEntity>> createProduct({
    required String name,
    required String sku,
    required double sellingPrice,
    required int initialQuantity,
    required double initialPurchasePrice,
  }) async {
    final qty = initialQuantity < 0 ? 0 : initialQuantity;
    final cost = initialPurchasePrice < 0 ? 0.0 : initialPurchasePrice;
    final now = DateTime.now();
    final id = _nextProductId++;
    final entity = ProductEntity(
      id: id,
      name: name,
      sku: sku,
      sellingPrice: sellingPrice,
      stockQuantity: qty,
      stockValue: qty * cost,
      averageCost: cost,
      createdAt: now,
      updatedAt: now,
    );
    _products.add(entity);
    _ledgers[id] = [
      ProductTransactionEntity(
        id: _nextTxnId++,
        productId: id,
        type: ProductTransactionType.initialStock,
        quantity: qty,
        unitPrice: cost,
        totalPrice: qty * cost,
        createdAt: now,
        isSynced: false,
      ),
    ];
    return Result.success(entity);
  }

  @override
  Future<Result<ProductEntity>> recordPurchase({
    required int productId,
    required int quantity,
    required double unitPrice,
    String? sourceName,
    String? sourceType,
    String? transactionId,
    String? quantityPerPackage,
  }) async {
    final current = _byId(productId);
    if (current == null) return _notFound(productId);

    final next = _wac.call(
      oldQuantity: current.stockQuantity,
      oldAverageCost: current.averageCost,
      transactionQuantity: quantity,
      transactionUnitPrice: unitPrice,
      op: WacOp.purchase,
    );
    final updated = _snapshotFrom(current, next.newQuantity, next.newAverageCost);
    _replace(updated);
    _appendTxn(
      productId,
      type: ProductTransactionType.purchase,
      quantity: quantity,
      unitPrice: unitPrice,
      sourceName: sourceName,
      sourceType: sourceType,
      transactionId: transactionId,
      quantityPerPackage: quantityPerPackage,
    );
    return Result.success(updated);
  }

  @override
  Future<Result<ProductEntity>> recordSale({
    required int productId,
    required int quantity,
    required double unitPrice,
    String? sourceName,
    String? sourceType,
    String? transactionId,
    String? quantityPerPackage,
  }) async {
    final current = _byId(productId);
    if (current == null) return _notFound(productId);
    if (current.stockQuantity < quantity) {
      return Result.failure(
        InsufficientStockFailure(
          productId: productId,
          available: current.stockQuantity,
          requested: quantity,
        ),
      );
    }

    final next = _wac.call(
      oldQuantity: current.stockQuantity,
      oldAverageCost: current.averageCost,
      transactionQuantity: quantity,
      transactionUnitPrice: unitPrice,
      op: WacOp.sale,
    );
    final updated = _snapshotFrom(current, next.newQuantity, current.averageCost);
    _replace(updated);
    _appendTxn(
      productId,
      type: ProductTransactionType.sale,
      quantity: quantity,
      unitPrice: unitPrice,
      sourceName: sourceName,
      sourceType: sourceType,
      transactionId: transactionId,
      quantityPerPackage: quantityPerPackage,
    );
    return Result.success(updated);
  }

  @override
  Future<Result<ProductEntity>> recordReturn({
    required int productId,
    required int quantity,
    required double unitPrice,
    String? sourceName,
    String? sourceType,
    String? transactionId,
    String? quantityPerPackage,
  }) async {
    final current = _byId(productId);
    if (current == null) return _notFound(productId);

    final next = _wac.call(
      oldQuantity: current.stockQuantity,
      oldAverageCost: current.averageCost,
      transactionQuantity: quantity,
      transactionUnitPrice: unitPrice,
      op: WacOp.returned,
    );
    final updated = _snapshotFrom(current, next.newQuantity, current.averageCost);
    _replace(updated);
    _appendTxn(
      productId,
      type: ProductTransactionType.returned,
      quantity: quantity,
      unitPrice: unitPrice,
      sourceName: sourceName,
      sourceType: sourceType,
      transactionId: transactionId,
      quantityPerPackage: quantityPerPackage,
    );
    return Result.success(updated);
  }

  @override
  Future<Result<List<ProductTransactionEntity>>> getTransactionsForProduct(
    int productId,
  ) async {
    final rows = List.of(_ledgers[productId] ?? const <ProductTransactionEntity>[])
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Result.success(rows);
  }

  @override
  Future<Result<List<ProductTransactionEntity>>> getAllProductTransactions() async {
    final rows = _ledgers.values
        .expand((rows) => rows)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return Result.success(rows);
  }

  @override
  Future<Result<List<ProductTransactionEntity>>> getUnsyncedTransactions({
    int limit = 500,
  }) async {
    return Result.success(const <ProductTransactionEntity>[]);
  }

  @override
  Future<Result<void>> markTransactionsSynced(List<int> ids) async {
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteProduct(int id) async {
    _products.removeWhere((p) => p.id == id);
    _ledgers.remove(id);
    return const Result.success(null);
  }

  @override
  Future<Result<List<int>>> deleteTransactionsByTransactionId(
    String transactionId,
  ) async {
    final affected = <int>{};
    for (final entry in _ledgers.entries) {
      final before = entry.value.length;
      entry.value.removeWhere((t) => t.transactionId == transactionId);
      if (entry.value.length != before) affected.add(entry.key);
    }
    return Result.success(affected.toList());
  }

  @override
  Future<Result<List<ProductEntity>>> rebuildSnapshotsForProducts(
    List<int> productIds,
  ) async {
    final rebuilt = <ProductEntity>[];
    for (final id in productIds) {
      final current = _byId(id);
      if (current == null) continue;
      final rows = List.of(_ledgers[id] ?? const <ProductTransactionEntity>[])
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      var quantity = 0;
      var averageCost = 0.0;
      for (final row in rows) {
        final op = switch (row.type) {
          ProductTransactionType.initialStock ||
          ProductTransactionType.purchase => WacOp.purchase,
          ProductTransactionType.sale => WacOp.sale,
          ProductTransactionType.returned => WacOp.returned,
        };
        final next = _wac.call(
          oldQuantity: quantity,
          oldAverageCost: averageCost,
          transactionQuantity: row.quantity,
          transactionUnitPrice: row.unitPrice,
          op: op,
        );
        quantity = next.newQuantity;
        averageCost = next.newAverageCost;
      }
      final updated = _snapshotFrom(current, quantity, averageCost);
      _replace(updated);
      rebuilt.add(updated);
    }
    return Result.success(rebuilt);
  }

  // ---------------- Internals ----------------

  ProductEntity? _byId(int id) {
    for (final p in _products) {
      if (p.id == id) return p;
    }
    return null;
  }

  void _replace(ProductEntity entity) {
    final index = _products.indexWhere((p) => p.id == entity.id);
    if (index >= 0) _products[index] = entity;
  }

  ProductEntity _snapshotFrom(ProductEntity current, int qty, double cost) {
    final now = DateTime.now();
    return ProductEntity(
      id: current.id,
      name: current.name,
      sku: current.sku,
      sellingPrice: current.sellingPrice,
      stockQuantity: qty,
      stockValue: qty * cost,
      averageCost: cost,
      createdAt: current.createdAt,
      updatedAt: now,
    );
  }

  void _appendTxn(
    int productId, {
    required ProductTransactionType type,
    required int quantity,
    required double unitPrice,
    String? sourceName,
    String? sourceType,
    String? transactionId,
    String? quantityPerPackage,
  }) {
    final rows = _ledgers[productId] ??= <ProductTransactionEntity>[];
    rows.add(
      ProductTransactionEntity(
        id: _nextTxnId++,
        productId: productId,
        type: type,
        quantity: quantity,
        unitPrice: unitPrice,
        totalPrice: quantity * unitPrice,
        createdAt: DateTime.now(),
        isSynced: false,
        sourceName: sourceName,
        sourceType: sourceType,
        transactionId: transactionId,
        quantityPerPackage: quantityPerPackage,
      ),
    );
  }

  Result<ProductEntity> _notFound(int productId) {
    return Result.failure(CacheFailure('Product not found: $productId'));
  }
}

/// Builds a [ProductBloc] backed by a fresh [FakeProductRepository].
ProductBloc buildProductBloc([FakeProductRepository? repository]) {
  final repo = repository ?? FakeProductRepository();
  return ProductBloc(
    getAllProducts: GetAllProductsUsecase(repo),
    createProduct: CreateProductUsecase(repo),
    deleteProduct: DeleteProductUsecase(repo),
    getProductTransactions: GetProductTransactionsUsecase(repo),
    recordPurchase: RecordPurchaseUsecase(repo),
    recordSale: RecordSaleUsecase(repo),
    recordReturn: RecordReturnUsecase(repo),
    deleteTransactionsByTransactionId:
        DeleteTransactionsByTransactionIdUsecase(repo),
    rebuildSnapshotsForProducts: RebuildSnapshotsForProductsUsecase(repo),
  );
}
