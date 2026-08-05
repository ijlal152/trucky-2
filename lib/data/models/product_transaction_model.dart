import 'package:trucky/core/database/product_transaction_table.dart';
import 'package:trucky/domain/entities/product_transaction_entity.dart';
import 'package:trucky/domain/entities/product_transaction_type.dart';

/// SQLite row mirror of `product_transactions_table`.
class ProductTransactionModel {
  const ProductTransactionModel({
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
  final double quantity;
  final double unitPrice;
  final double totalPrice;
  final DateTime createdAt;
  final bool isSynced;

  factory ProductTransactionModel.fromMap(Map<String, Object?> map) {
    return ProductTransactionModel(
      id: map[ProductTransactionTable.id] as String,
      productId: map[ProductTransactionTable.productId] as String,
      type: _typeFromString(
        map[ProductTransactionTable.type] as String,
      ),
      quantity: (map[ProductTransactionTable.quantity] as num).toDouble(),
      unitPrice: (map[ProductTransactionTable.unitPrice] as num).toDouble(),
      totalPrice: (map[ProductTransactionTable.totalPrice] as num).toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[ProductTransactionTable.createdAt] as int,
      ),
      isSynced:
          (map[ProductTransactionTable.isSynced] as int? ?? 0) == 1,
    );
  }

  Map<String, Object?> toMap() => {
        ProductTransactionTable.id: id,
        ProductTransactionTable.productId: productId,
        ProductTransactionTable.type: type.value,
        ProductTransactionTable.quantity: quantity,
        ProductTransactionTable.unitPrice: unitPrice,
        ProductTransactionTable.totalPrice: totalPrice,
        ProductTransactionTable.createdAt: createdAt.millisecondsSinceEpoch,
        ProductTransactionTable.isSynced: isSynced ? 1 : 0,
      };

  ProductTransactionEntity toEntity() => ProductTransactionEntity(
        id: id,
        productId: productId,
        type: type,
        quantity: quantity,
        unitPrice: unitPrice,
        totalPrice: totalPrice,
        createdAt: createdAt,
        isSynced: isSynced,
      );

  static ProductTransactionType _typeFromString(String raw) {
    return ProductTransactionTypeX.fromString(raw);
  }
}
