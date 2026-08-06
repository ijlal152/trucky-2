/// Inventory snapshot for a single product.
///
/// The product table is a **cache**: it stores pre-computed aggregates so the
/// UI can render without scanning the transaction log. The ledger is the
/// source of truth; this snapshot is replaceable from the ledger.
class ProductEntity {
  const ProductEntity({
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

  /// True if there is any stock on hand.
  bool get isInStock => stockQuantity > 0;

  /// Profit margin per unit using the current WAC.
  double get effectiveCost => averageCost;
  double get profitPerUnit => sellingPrice - effectiveCost;
}
