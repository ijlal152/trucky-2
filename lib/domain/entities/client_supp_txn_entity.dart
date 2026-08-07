/// A transaction (sale/purchase/payment/refund) against a client or supplier.
class ClientSuppTxnEntity {
  const ClientSuppTxnEntity({
    this.id,
    required this.userId,
    required this.clientSuppId,
    required this.transactionId,
    required this.clientSupplierName,
    required this.role,
    required this.txnData,
    this.discountAmount = '0',
    required this.amount,
    required this.paymentType,
    this.note,
    this.isSynced = false,
  });

  final int? id;
  final int userId;
  final int clientSuppId;
  final String transactionId;
  final String clientSupplierName;
  final String role;
  final DateTime txnData;
  final String discountAmount;
  final String amount;
  final String paymentType;
  final String? note;
  final bool isSynced;
}