import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trucky/domain/entities/product_entity.dart';
import 'package:trucky/domain/entities/product_transaction_entity.dart';

part 'product_models.freezed.dart';

/// Presentation model: the product snapshot used by the UI.
///
/// This is a 1:1 mirror of [ProductEntity] but uses `double` for stock and
/// keeps `purchaseValue` derived from `selling_price` to match the existing
/// product list rendering.
@freezed
abstract class Product with _$Product {
  const factory Product({
    String? id,
    required String productName,
    required double purchasePrice,
    required double sellingPrice,
    @Default(0) double availableStock,
    String? quantityPerPackage,
    String? productImage,
    String? productSKU,
    double? weightedAverageCost,
    DateTime? createdAt,
    /// Authoritative WAC from the snapshot (preferred over purchasePrice).
    double? averageCost,
  }) = _Product;

  const Product._();

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

  double get effectiveCost => averageCost ?? weightedAverageCost ?? purchasePrice;

  /// Build a presentation [Product] from the domain entity.
  static Product fromEntity(ProductEntity e) {
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
}

/// A single product transaction used on the product dashboard.
@freezed
abstract class ProductDetail with _$ProductDetail {
  const factory ProductDetail({
    required String productId,
    String? sourceName,
    String? sourceType,
    required double purchasePrice,
    required double sellingPrice,
    required double quantity,
    required String paymentType,
    required DateTime createdAt,
    /// Shared id linking this detail to its parent transaction, if any.
    String? transactionId,
    String? quantityPerPackage,
  }) = _ProductDetail;

  const ProductDetail._();

  /// Build a presentation [ProductDetail] from the domain entity.
  static ProductDetail fromEntity(ProductTransactionEntity e) {
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
