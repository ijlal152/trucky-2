import 'package:trucky/core/utils/result.dart';
import 'package:trucky/domain/entities/product_entity.dart';
import 'package:trucky/domain/entities/product_transaction_entity.dart';

/// Domain-level contract for product & inventory operations.
///
/// Repositories return [Result] instead of throwing; data sources may throw
/// low-level exceptions which the implementation translates into failures.
abstract interface class ProductRepository {
  /// Returns all products (snapshot) ordered by creation time ascending.
  Future<Result<List<ProductEntity>>> getAllProducts();

  /// Returns the cached snapshot for a single product, or null if missing.
  Future<Result<ProductEntity?>> getProductById(String id);

  /// Creates a new product with an opening purchase transaction. Returns the
  /// newly created product entity (with its generated id).
  Future<Result<ProductEntity>> createProduct({
    required String name,
    required String sku,
    required double sellingPrice,
    required double initialQuantity,
    required double initialPurchasePrice,
  });

  /// Records a purchase, blending new stock into the existing WAC.
  Future<Result<ProductEntity>> recordPurchase({
    required String productId,
    required double quantity,
    required double unitPrice,
  });

  /// Records a sale. Throws [ValidationFailure] when there is not
  /// enough stock.
  Future<Result<ProductEntity>> recordSale({
    required String productId,
    required double quantity,
    required double unitPrice,
  });

  /// Records a return (purchase-return or sale-return). Stock is added back at
  /// the **current** WAC. `unitPrice` is informational (audit only).
  Future<Result<ProductEntity>> recordReturn({
    required String productId,
    required double quantity,
    required double unitPrice,
  });

  /// Returns the full transaction history for a product, newest first.
  Future<Result<List<ProductTransactionEntity>>> getTransactionsForProduct(
    String productId,
  );

  /// Returns all unsynced transactions, ordered by `created_at ASC`.
  Future<Result<List<ProductTransactionEntity>>> getUnsyncedTransactions({
    int limit = 500,
  });

  /// Marks the given transactions as synced. Idempotent.
  Future<Result<void>> markTransactionsSynced(List<String> ids);

  /// Removes a product and (via FK cascade) all of its transactions.
  Future<Result<void>> deleteProduct(String id);
}
