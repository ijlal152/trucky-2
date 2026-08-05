import 'package:trucky/core/database/table_names.dart';

abstract final class ProductTable {
  static const String name = TableNames.productsTable;

  static const String id = 'id';
  static const String productName = 'name';
  static const String sku = 'sku';
  static const String sellingPrice = 'selling_price';
  static const String stockQuantity = 'stock_quantity';
  static const String stockValue = 'stock_value';
  static const String averageCost = 'average_cost';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}
