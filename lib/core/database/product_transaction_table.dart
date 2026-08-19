import 'package:trucky/core/database/table_names.dart';

abstract final class ProductTransactionTable {
  static const String name = TableNames.productTransactionTable;

  static const String id = 'id';
  static const String productId = 'product_id';
  static const String type = 'type';
  static const String quantity = 'quantity';
  static const String unitPrice = 'unit_price';
  static const String totalPrice = 'total_price';
  static const String createdAt = 'created_at';
  static const String isSynced = 'is_synced';
  static const String sourceName = 'source_name';
  static const String sourceType = 'source_type';
  static const String transactionId = 'transaction_id';
  static const String quantityPerPackage = 'quantity_per_package';
}
