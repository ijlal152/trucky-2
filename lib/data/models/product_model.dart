import 'package:trucky/core/database/product_table.dart';
import 'package:trucky/domain/entities/product_entity.dart';

/// SQLite row mirror of `products_table`.
///
/// Plain Dart class — no codegen. `fromMap` / `toMap` are 1:1 with the
/// column constants in `ProductTable` so a renamed column becomes a compile
/// error here, not a silent runtime bug.
class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.sellingPrice,
    required this.stockQuantity,
    required this.stockValue,
    required this.averageCost,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String sku;
  final double sellingPrice;
  final int stockQuantity;
  final double stockValue;
  final double averageCost;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory ProductModel.fromMap(Map<String, Object?> map) {
    return ProductModel(
      id: map[ProductTable.id] as String,
      name: map[ProductTable.productName] as String,
      sku: map[ProductTable.sku] as String,
      sellingPrice: (map[ProductTable.sellingPrice] as num).toDouble(),
      stockQuantity: map[ProductTable.stockQuantity] as int,
      stockValue: (map[ProductTable.stockValue] as num).toDouble(),
      averageCost: (map[ProductTable.averageCost] as num).toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[ProductTable.createdAt] as int,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        map[ProductTable.updatedAt] as int,
      ),
    );
  }

  Map<String, Object?> toMap() => {
        ProductTable.id: id,
        ProductTable.productName: name,
        ProductTable.sku: sku,
        ProductTable.sellingPrice: sellingPrice,
        ProductTable.stockQuantity: stockQuantity,
        ProductTable.stockValue: stockValue,
        ProductTable.averageCost: averageCost,
        ProductTable.createdAt: createdAt.millisecondsSinceEpoch,
        ProductTable.updatedAt: updatedAt.millisecondsSinceEpoch,
      };

  ProductEntity toEntity() => ProductEntity(
        id: id,
        name: name,
        sku: sku,
        sellingPrice: sellingPrice,
        stockQuantity: stockQuantity,
        stockValue: stockValue,
        averageCost: averageCost,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  ProductModel copyWith({
    String? id,
    String? name,
    String? sku,
    double? sellingPrice,
    int? stockQuantity,
    double? stockValue,
    double? averageCost,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      stockValue: stockValue ?? this.stockValue,
      averageCost: averageCost ?? this.averageCost,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
