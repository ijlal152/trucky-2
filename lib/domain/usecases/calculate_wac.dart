/// Single source of truth for inventory math.
///
/// All WAC / stock-quantity / stock-value calculations are performed by these
/// pure functions. The repository calls them inside a SQLite transaction so
/// the snapshot and the ledger stay consistent.
///
/// Per the design doc:
///   * PURCHASE blends new stock into the existing average.
///   * SALE and RETURN never change the average cost.
class CalculateWac {
  const CalculateWac();

  /// Result of applying a transaction to the snapshot.
  NextSnapshot call({
    required int oldQuantity,
    required double oldAverageCost,
    required int transactionQuantity,
    required double transactionUnitPrice,
    required WacOp op,
  }) {
    final qty = transactionQuantity;
    if (qty < 0) {
      throw ArgumentError('Transaction quantity must be non-negative.');
    }
    if (op == WacOp.purchase) {
      final newQty = oldQuantity + qty;
      final newAvg = newQty == 0
          ? transactionUnitPrice
          : ((oldQuantity * oldAverageCost) + (qty * transactionUnitPrice)) /
              newQty;
      return NextSnapshot(
        newQuantity: newQty,
        newAverageCost: newAvg,
      );
    }
    // Sale and Return do not change WAC.
    final delta = op == WacOp.sale ? -qty : qty;
    final newQty = oldQuantity + delta;
    if (newQty < 0) {
      throw StateError(
        'Negative stock would result: old=$oldQuantity delta=$delta',
      );
    }
    return NextSnapshot(
      newQuantity: newQty,
      newAverageCost: oldAverageCost,
    );
  }
}

/// Discriminated op for WAC updates.
///
/// `returnPurchase` and `returnSale` are kept as distinct cases so future
/// policy changes (e.g., refund pricing) can branch on intent.
enum WacOp { purchase, sale, returned }

extension WacOpX on WacOp {
  bool get isPurchase => this == WacOp.purchase;
  bool get isSale => this == WacOp.sale;
  bool get isReturn => this == WacOp.returned;
}

/// Output of a single WAC step.
class NextSnapshot {
  const NextSnapshot({
    required this.newQuantity,
    required this.newAverageCost,
  });

  final int newQuantity;
  final double newAverageCost;

  double get newStockValue => newQuantity * newAverageCost;
}
