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
    required this.isSynced,
  });

  final String id;
  final String productId;
  final ProductTransactionType type;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final DateTime createdAt;
  final bool isSynced;
}
