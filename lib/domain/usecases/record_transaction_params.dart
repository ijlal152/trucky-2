/// Shared input for the sale/purchase/return record use cases.
class RecordTransactionParams {
  const RecordTransactionParams({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.sourceName,
    this.sourceType,
  });

  final String productId;
  final int quantity;
  final double unitPrice;
  final String? sourceName;
  final String? sourceType;
}
