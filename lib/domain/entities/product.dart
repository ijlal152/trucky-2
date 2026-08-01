class Product {
  final int? id;
  final String name;
  final String? imagePath;
  final int supplierId;
  final double purchasePrice;
  final double sellingPrice;
  final int stockQuantity;
  final double totalStockValue;
  final bool isSynced;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    this.id,
    required this.name,
    this.imagePath,
    required this.supplierId,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stockQuantity,
    required this.totalStockValue,
    required this.isSynced,
    required this.createdAt,
    required this.updatedAt,
  });
}
