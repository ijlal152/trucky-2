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
    this.sourceName,
    this.sourceType,
  });

  final int id;
  final int productId;
  final ProductTransactionType type;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final DateTime createdAt;
  final bool isSynced;
  final String? sourceName;
  final String? sourceType;

  factory ProductTransactionModel.fromMap(Map<String, Object?> map) {
    return ProductTransactionModel(
      id: map[ProductTransactionTable.id] as int,
      productId: map[ProductTransactionTable.productId] as int,
      type: _typeFromString(map[ProductTransactionTable.type] as String),
      quantity: map[ProductTransactionTable.quantity] as int,
      unitPrice: (map[ProductTransactionTable.unitPrice] as num).toDouble(),
      totalPrice: (map[ProductTransactionTable.totalPrice] as num).toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[ProductTransactionTable.createdAt] as int,
      ),
      isSynced: (map[ProductTransactionTable.isSynced] as int? ?? 0) == 1,
      sourceName: map[ProductTransactionTable.sourceName] as String?,
      sourceType: map[ProductTransactionTable.sourceType] as String?,
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
    ProductTransactionTable.sourceName: sourceName,
    ProductTransactionTable.sourceType: sourceType,
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
    sourceName: sourceName,
    sourceType: sourceType,
  );

  static ProductTransactionType _typeFromString(String raw) {
    return ProductTransactionTypeX.fromString(raw);
  }
}
