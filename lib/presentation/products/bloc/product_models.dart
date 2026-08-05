import 'package:trucky/domain/entities/product_entity.dart';
import 'package:trucky/domain/entities/product_transaction_entity.dart';

/// Presentation model: the product snapshot used by the UI.
///
/// This is a 1:1 mirror of [ProductEntity] but uses `double` for stock and
/// keeps `purchaseValue` derived from `selling_price` to match the existing
/// product list rendering.
class Product {
  const Product({
    this.id,
    required this.productName,
    required this.purchasePrice,
    required this.sellingPrice,
    this.availableStock = 0,
    this.quantityPerPackage,
    this.productImage,
    this.productSKU,
    this.weightedAverageCost,
    this.createdAt,
    this.averageCost,
  });

  final String? id;
  final String productName;
  final double purchasePrice;
  final double sellingPrice;
  final double availableStock;
  final String? quantityPerPackage;
  final String? productImage;
  final String? productSKU;
  final double? weightedAverageCost;
  final DateTime? createdAt;

  /// Authoritative WAC from the snapshot (preferred over purchasePrice).
  final double? averageCost;

  double get profit => sellingPrice - purchasePrice;

  bool get isInStock => availableStock > 0;

  /// Total stock value at WAC.
  double get totalValue {
    final cost = weightedAverageCost ?? purchasePrice;
    return availableStock * cost;
  }

  /// Backwards-compat alias: the existing UI uses "purchaseValue" to mean
  /// the stock value displayed on the product card. We keep that name to
  /// avoid touching every widget.
  double get purchaseValue => totalValue;

  double get effectiveCost =>
      averageCost ?? weightedAverageCost ?? purchasePrice;

  /// Build a presentation [Product] from the domain entity.
  factory Product.fromEntity(ProductEntity e) {
    return Product(
      id: e.id,
      productName: e.name,
      // The legacy UI needs a "purchase price" string for display. The
      // snapshot stores `average_cost` as the canonical per-unit cost;
      // expose it as `purchasePrice` so existing widgets render correctly.
      purchasePrice: e.averageCost,
      sellingPrice: e.sellingPrice,
      availableStock: e.stockQuantity,
      productSKU: e.sku,
      weightedAverageCost: e.averageCost,
      averageCost: e.averageCost,
      createdAt: e.createdAt,
    );
  }

  Product copyWith({
    String? id,
    String? productName,
    double? purchasePrice,
    double? sellingPrice,
    double? availableStock,
    String? quantityPerPackage,
    String? productImage,
    String? productSKU,
    double? weightedAverageCost,
    DateTime? createdAt,
    double? averageCost,
  }) {
    return Product(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      availableStock: availableStock ?? this.availableStock,
      quantityPerPackage: quantityPerPackage ?? this.quantityPerPackage,
      productImage: productImage ?? this.productImage,
      productSKU: productSKU ?? this.productSKU,
      weightedAverageCost: weightedAverageCost ?? this.weightedAverageCost,
      createdAt: createdAt ?? this.createdAt,
      averageCost: averageCost ?? this.averageCost,
    );
  }
}

/// A single product transaction used on the product dashboard.
class ProductDetail {
  const ProductDetail({
    required this.productId,
    this.sourceName,
    this.sourceType,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.quantity,
    required this.paymentType,
    required this.createdAt,
    this.transactionId,
    this.quantityPerPackage,
  });

  final String productId;
  final String? sourceName;
  final String? sourceType;
  final double purchasePrice;
  final double sellingPrice;
  final double quantity;
  final String paymentType;
  final DateTime createdAt;

  /// Shared id linking this detail to its parent transaction, if any.
  final String? transactionId;

  final String? quantityPerPackage;

  /// Build a presentation [ProductDetail] from the domain entity.
  factory ProductDetail.fromEntity(ProductTransactionEntity e) {
    return ProductDetail(
      productId: e.productId,
      sourceName: e.type.name,
      sourceType: e.type.name,
      purchasePrice: e.unitPrice,
      sellingPrice: e.unitPrice,
      quantity: e.quantity,
      paymentType: _humanize(e.type.name),
      createdAt: e.createdAt,
      transactionId: e.id,
    );
  }

  static String _humanize(String raw) {
    switch (raw) {
      case 'purchase':
        return 'Purchase';
      case 'sale':
        return 'Sale';
      case 'return':
        return 'Return';
      default:
        return raw;
    }
  }
}
