import 'package:trucky/domain/entities/client_supp_entity.dart';
import 'package:trucky/domain/entities/client_supp_txn_entity.dart';
import 'package:trucky/presentation/products/bloc/product_models.dart';

/// Model representing a Client or Supplier.
class ClientSupp {
  const ClientSupp({
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

  factory ClientSupp.empty() {
    return ClientSupp(
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

  factory ClientSupp.fromEntity(ClientSuppEntity entity) {
    return ClientSupp(
      id: entity.id,
      name: entity.name,
      role: entity.role,
      phoneNumber: entity.phoneNumber ?? '',
      gpsLocation: entity.gpsLocation ?? '',
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ClientSupp copyWith({
    int? id,
    String? name,
    String? role,
    String? phoneNumber,
    String? gpsLocation,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ClientSuppTxn>? transactions,
  }) {
    return ClientSupp(
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
    this.discountAmount = '0',
    this.note,
    this.products = const [],
  });

  final int? id;
  final int clientSuppId;
  final String transactionId;
  final String clientSupplierName;
  final String role;
  final DateTime txnData;
  final String amount;
  final String paymentType;
  final String discountAmount;
  final String? note;
  final List<ProductDetail> products;

  factory ClientSuppTxn.fromEntity(ClientSuppTxnEntity entity) {
    return ClientSuppTxn(
      id: entity.id,
      clientSuppId: entity.clientSuppId,
      transactionId: entity.transactionId,
      clientSupplierName: entity.clientSupplierName,
      role: entity.role,
      txnData: entity.txnData,
      amount: entity.amount,
      paymentType: entity.paymentType,
      discountAmount: entity.discountAmount,
      note: entity.note,
    );
  }

  ClientSuppTxn copyWith({
    int? id,
    int? clientSuppId,
    String? transactionId,
    String? clientSupplierName,
    String? role,
    DateTime? txnData,
    String? amount,
    String? paymentType,
    String? discountAmount,
    String? note,
    List<ProductDetail>? products,
  }) {
    return ClientSuppTxn(
      id: id ?? this.id,
      clientSuppId: clientSuppId ?? this.clientSuppId,
      transactionId: transactionId ?? this.transactionId,
      clientSupplierName: clientSupplierName ?? this.clientSupplierName,
      role: role ?? this.role,
      txnData: txnData ?? this.txnData,
      amount: amount ?? this.amount,
      paymentType: paymentType ?? this.paymentType,
      discountAmount: discountAmount ?? this.discountAmount,
      note: note ?? this.note,
      products: products ?? this.products,
    );
  }

  /// Calculate current balance for a specific client/supplier.
  static double calculateCurrentBalance({
    required int clientSupplierId,
    required List<ClientSuppTxn> allTransactions,
  }) {
    final transactions =
        allTransactions
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
    return runningBalances(transactions)[index];
  }

  /// Running balance at every index in a single backward pass.
  ///
  /// Equivalent to calling [calculateBalanceAtIndex] for each index, but O(n)
  /// instead of O(n²) — use this when rendering a list of transactions.
  static List<double> runningBalances(List<ClientSuppTxn> transactions) {
    final balances = List<double>.filled(transactions.length, 0);
    double balance = 0.0;
    for (int i = transactions.length - 1; i >= 0; i--) {
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
      balances[i] = balance;
    }
    return balances;
  }
}
