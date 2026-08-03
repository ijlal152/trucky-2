import 'package:trucky/core/database/table_names.dart';

/// Column scheme for the `product_transactions_table`.
///
/// Mirrors the fields of the legacy Hive model (`ProductDetailsHiveModel`)
/// so DAOs and repositories can reference columns without stringly-typed SQL.
abstract final class ProductTransactionTable {
  static const String name = TableNames.productTransactionTable;

  static const String id = 'id';
  static const String userId = 'user_id';
  static const String productId = 'product_id';
  static const String sourceId = 'source_id';
  static const String sourceName = 'source_name';
  static const String transactionId = 'transaction_id';
  static const String sourceType = 'source_type';
  static const String purchasePrice = 'purchase_price';
  static const String sellingPrice = 'selling_price';
  static const String quantity = 'quantity';
  static const String quantityPerPackage = 'quantity_per_package';
  static const String paymentType = 'payment_type';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
  static const String isSynced = 'is_synced';
}
