import 'package:trucky/core/database/client_supp_txn_table.dart';
import 'package:trucky/domain/entities/client_supp_txn_entity.dart';

/// SQLite row mirror of `client_supp_transactions_table`.
///
/// Plain Dart class — no codegen. `fromMap` / `toMap` are 1:1 with the
/// column constants in `ClientSuppTxnTable` so a renamed column becomes a
/// compile error here, not a silent runtime bug.
class ClientSuppTxnModel {
  const ClientSuppTxnModel({
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

  factory ClientSuppTxnModel.fromMap(Map<String, Object?> map) {
    return ClientSuppTxnModel(
      id: map[ClientSuppTxnTable.id] as int?,
      userId: map[ClientSuppTxnTable.userId] as int,
      clientSuppId: map[ClientSuppTxnTable.clientSuppId] as int,
      transactionId: map[ClientSuppTxnTable.transactionId] as String,
      clientSupplierName: map[ClientSuppTxnTable.clientSupplierName] as String,
      role: map[ClientSuppTxnTable.role] as String,
      txnData: DateTime.fromMillisecondsSinceEpoch(
        map[ClientSuppTxnTable.txnData] as int,
      ),
      discountAmount: map[ClientSuppTxnTable.discountAmount] as String,
      amount: map[ClientSuppTxnTable.amount] as String,
      paymentType: map[ClientSuppTxnTable.paymentType] as String,
      note: map[ClientSuppTxnTable.note] as String?,
      isSynced: (map[ClientSuppTxnTable.isSynced] as int) == 1,
    );
  }

  Map<String, Object?> toMap() => {
    if (id != null) ClientSuppTxnTable.id: id,
    ClientSuppTxnTable.userId: userId,
    ClientSuppTxnTable.clientSuppId: clientSuppId,
    ClientSuppTxnTable.transactionId: transactionId,
    ClientSuppTxnTable.clientSupplierName: clientSupplierName,
    ClientSuppTxnTable.role: role,
    ClientSuppTxnTable.txnData: txnData.millisecondsSinceEpoch,
    ClientSuppTxnTable.discountAmount: discountAmount,
    ClientSuppTxnTable.amount: amount,
    ClientSuppTxnTable.paymentType: paymentType,
    ClientSuppTxnTable.note: note,
    ClientSuppTxnTable.isSynced: isSynced ? 1 : 0,
  };

  ClientSuppTxnEntity toEntity() => ClientSuppTxnEntity(
    id: id,
    userId: userId,
    clientSuppId: clientSuppId,
    transactionId: transactionId,
    clientSupplierName: clientSupplierName,
    role: role,
    txnData: txnData,
    discountAmount: discountAmount,
    amount: amount,
    paymentType: paymentType,
    note: note,
    isSynced: isSynced,
  );

  factory ClientSuppTxnModel.fromEntity(ClientSuppTxnEntity entity) =>
      ClientSuppTxnModel(
        id: entity.id,
        userId: entity.userId,
        clientSuppId: entity.clientSuppId,
        transactionId: entity.transactionId,
        clientSupplierName: entity.clientSupplierName,
        role: entity.role,
        txnData: entity.txnData,
        discountAmount: entity.discountAmount,
        amount: entity.amount,
        paymentType: entity.paymentType,
        note: entity.note,
        isSynced: entity.isSynced,
      );
}