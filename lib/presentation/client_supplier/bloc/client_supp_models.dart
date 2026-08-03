/// Model representing a Client or Supplier.
class ClientSuppEntity {
  const ClientSuppEntity({
    this.id,
    required this.name,
    required this.role,
    required this.phoneNumber,
    required this.gpsLocation,
    required this.createdAt,
    this.updatedAt,
    this.transactions = const [],
  });

  final int? id;
  final String name;
  final String role;
  final String phoneNumber;
  final String gpsLocation;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<ClientSuppTxn> transactions;

  factory ClientSuppEntity.empty() {
    return ClientSuppEntity(
      id: null,
      name: '',
      role: '',
      phoneNumber: '',
      gpsLocation: '',
      createdAt: DateTime.now(),
      updatedAt: null,
      transactions: const [],
    );
  }

  ClientSuppEntity copyWith({
    int? id,
    String? name,
    String? role,
    String? phoneNumber,
    String? gpsLocation,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ClientSuppTxn>? transactions,
  }) {
    return ClientSuppEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gpsLocation: gpsLocation ?? this.gpsLocation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      transactions: transactions ?? this.transactions,
    );
  }
}

/// Model representing a Client/Supplier transaction.
class ClientSuppTxn {
  const ClientSuppTxn({
    this.id,
    required this.clientSuppId,
    required this.transactionId,
    required this.clientSupplierName,
    required this.role,
    required this.txnData,
    required this.amount,
    required this.paymentType,
    this.note,
  });

  final int? id;
  final int clientSuppId;
  final String transactionId;
  final String clientSupplierName;
  final String role;
  final DateTime txnData;
  final String amount;
  final String paymentType;
  final String? note;

  /// Calculate current balance for a specific client/supplier.
  static double calculateCurrentBalance({
    required int clientSupplierId,
    required List<ClientSuppTxn> allTransactions,
  }) {
    final transactions = allTransactions
        .where((txn) => txn.clientSuppId == clientSupplierId)
        .toList()
      ..sort((a, b) => a.txnData.compareTo(b.txnData));

    if (transactions.isEmpty) return 0.0;

    double currentBalance = 0.0;
    for (final txn in transactions) {
      final amt = double.tryParse(txn.amount) ?? 0.0;
      switch (txn.paymentType) {
        case 'Initial Balance':
          currentBalance = amt;
          break;
        case 'Sale':
        case 'Purchase':
          currentBalance += amt;
          break;
        case 'Payment':
        case 'Return':
          currentBalance -= amt;
          break;
        case 'Refund':
          currentBalance += amt;
          break;
      }
    }
    return currentBalance;
  }

  /// Calculate balance at a specific transaction index.
  static double calculateBalanceAtIndex({
    required List<ClientSuppTxn> transactions,
    required int index,
  }) {
    if (transactions.isEmpty || index >= transactions.length) return 0.0;

    double balance = 0.0;
    for (int i = transactions.length - 1; i >= index; i--) {
      final txn = transactions[i];
      final amt = double.tryParse(txn.amount) ?? 0.0;
      switch (txn.paymentType) {
        case 'Initial Balance':
          balance = amt;
          break;
        case 'Sale':
        case 'Purchase':
        case 'Refund':
          balance += amt;
          break;
        case 'Payment':
        case 'Return':
          balance -= amt;
          break;
      }
    }
    return balance;
  }
}
