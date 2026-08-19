import 'package:trucky/domain/entities/product_transaction_type.dart';

/// A single line in the inventory ledger.
///
/// This is the **source of truth**. The snapshot aggregate on the
/// `ProductEntity` is derived from these rows on every write and on
/// demand if a self-healing replay is required.
class ProductTransactionEntity {
  const ProductTransactionEntity({
    required this.id,
    required this.productId,
    required this.type,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.createdAt,
    required     this.isSynced,
    this.sourceName,
    this.sourceType,
    this.transactionId,
    this.quantityPerPackage,
  });

  final int id;
  final int productId;
  final ProductTransactionType type;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final DateTime createdAt;
  final bool isSynced;

  /// Optional client/supplier name this transaction originated from.
  final String? sourceName;

  /// Optional counterparty role ('client' or 'supplier').
  final String? sourceType;

  /// Id of the parent Sale/Purchase/Return transaction this ledger row
  /// belongs to, used to read a transaction's products back from the
  /// database (mirrors the legacy `product_details.transactionId`).
  final String? transactionId;

  /// Per-package quantity captured at write time (restored into the edit
  /// cart). Null when unknown.
  final String? quantityPerPackage;
}
