/// Shared input for the sale/purchase/return record use cases.
class RecordTransactionParams {
  const RecordTransactionParams({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    this.sourceName,
    this.sourceType,
    this.transactionId,
    this.quantityPerPackage,
  });

  final int productId;
  final int quantity;
  final double unitPrice;
  final String? sourceName;
  final String? sourceType;

  /// Parent Sale/Purchase/Return transaction id, persisted on the ledger row
  /// so the transaction's products can be read back from the database.
  final String? transactionId;

  /// Per-package quantity preserved from the submitted cart line.
  final String? quantityPerPackage;
}
