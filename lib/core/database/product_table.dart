import 'package:trucky/core/database/table_names.dart';

/// Column scheme for the `products_table`.
///
/// Mirrors the fields of the legacy Hive model (`ProductHiveModel`) so DAOs
/// and repositories can reference columns without stringly-typed SQL.
abstract final class ProductTable {
  static const String name = TableNames.productsTable;

  static const String id = 'id';
  static const String userId = 'user_id';
  static const String productName = 'product_name';
  static const String productSku = 'product_sku';
  static const String purchasePrice = 'purchase_price';
  static const String sellingPrice = 'selling_price';
  static const String quantityPerPackage = 'quantity_per_package';
  static const String productImage = 'product_image';
  static const String isSynced = 'is_synced';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}
