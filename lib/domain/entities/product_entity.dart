import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    super.id,
    required super.name,
    super.imagePath,
    required super.supplierId,
    required super.purchasePrice,
    required super.sellingPrice,
    required super.stockQuantity,
    required super.totalStockValue,
    required super.isSynced,
    required super.createdAt,
    required super.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_path': imagePath,
      'supplier_id': supplierId,
      'purchase_price': purchasePrice,
      'selling_price': sellingPrice,
      'stock_quantity': stockQuantity,
      'total_stock_value': totalStockValue,
      'is_synced': isSynced ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      imagePath: map['image_path'],
      supplierId: map['supplier_id'],
      purchasePrice: map['purchase_price'],
      sellingPrice: map['selling_price'],
      stockQuantity: map['stock_quantity'],
      totalStockValue: map['total_stock_value'],
      isSynced: map['is_synced'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      imagePath: product.imagePath,
      supplierId: product.supplierId,
      purchasePrice: product.purchasePrice,
      sellingPrice: product.sellingPrice,
      stockQuantity: product.stockQuantity,
      totalStockValue: product.totalStockValue,
      isSynced: product.isSynced,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
    );
  }
}
