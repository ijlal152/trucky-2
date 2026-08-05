/// Inventory transaction types accepted by the inventory engine.
///
/// Direction (in/out of stock) is derived from this enum, not stored as a
/// sign on `quantity`. Quantities are always positive magnitudes.
enum ProductTransactionType {
  purchase,
  sale,
  returned,
}

extension ProductTransactionTypeX on ProductTransactionType {
  String get value {
    if (this == ProductTransactionType.returned) return 'return';
    return name;
  }

  static ProductTransactionType fromString(String raw) {
    switch (raw) {
      case 'purchase':
        return ProductTransactionType.purchase;
      case 'sale':
        return ProductTransactionType.sale;
      case 'return':
        return ProductTransactionType.returned;
      default:
        throw FormatException('Unknown transaction type: $raw');
    }
  }
}
