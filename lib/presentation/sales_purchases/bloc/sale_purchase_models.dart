import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';
import 'package:trucky/presentation/products/bloc/product_models.dart';

/// The kind of payment/settlement being recorded.
enum PaymentTransactionType {
  salePayment,
  directPayment,
  refund,
  returnPayment,
}

/// A product line in the sale/purchase cart.
class CartItem {
  const CartItem({
    required this.product,
    this.quantity = 1,
    this.unitPrice = 0,
    this.quantityPerPackage,
  });

  final Product product;
  final int quantity;
  final double unitPrice;
  final String? quantityPerPackage;

  /// Builds an item priced according to the active entity type: suppliers pay
  /// purchase price, clients pay selling price.
  factory CartItem.fromProduct(
    Product product,
    EntityType entityType, {
    int quantity = 1,
  }) {
    return CartItem(
      product: product,
      quantity: quantity,
      unitPrice: entityType == EntityType.supplier
          ? product.purchasePrice
          : product.sellingPrice,
      quantityPerPackage: product.quantityPerPackage,
    );
  }

  double get lineTotal => unitPrice * quantity;

  CartItem copyWith({
    int? quantity,
    double? unitPrice,
    String? quantityPerPackage,
  }) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      quantityPerPackage: quantityPerPackage ?? this.quantityPerPackage,
    );
  }
}

/// Transfer object carried between the cart, payment details and invoice.
class PaymentDataModel {
  const PaymentDataModel({
    required this.paymentType,
    required this.clientSupplier,
    this.oldBalance = 0,
    this.currentOrderAmount = 0,
    this.paymentAmount = 0,
    this.notes = '',
    this.products,
    this.discount = 0,
    this.dateTime,
  });

  final PaymentTransactionType paymentType;
  final ClientSupp? clientSupplier;
  final double oldBalance;
  final double currentOrderAmount;
  final double paymentAmount;
  final String notes;
  final List<CartItem>? products;
  final double discount;
  final DateTime? dateTime;

  /// Balance right after this order, before any payment.
  double get currentBalance {
    switch (paymentType) {
      case PaymentTransactionType.salePayment:
        return oldBalance + currentOrderAmount;
      case PaymentTransactionType.directPayment:
      case PaymentTransactionType.refund:
        return oldBalance;
      case PaymentTransactionType.returnPayment:
        return oldBalance - currentOrderAmount;
    }
  }

  /// Balance after the recorded payment/refund.
  double get newBalance {
    switch (paymentType) {
      case PaymentTransactionType.salePayment:
      case PaymentTransactionType.directPayment:
        return currentBalance - paymentAmount;
      case PaymentTransactionType.refund:
        return currentBalance + paymentAmount;
      case PaymentTransactionType.returnPayment:
        return currentBalance - paymentAmount;
    }
  }

  /// The exact persisted payment-type string.
  String get paymentTypeString {
    switch (paymentType) {
      case PaymentTransactionType.salePayment:
        return clientSupplier?.role == 'supplier' ? 'Purchase' : 'Sale';
      case PaymentTransactionType.directPayment:
        return 'Payment';
      case PaymentTransactionType.refund:
        return 'Refund';
      case PaymentTransactionType.returnPayment:
        return 'Return';
    }
  }

  factory PaymentDataModel.fromTransaction({
    required ClientSupp? clientSupplier,
    required double oldBalance,
    required double totalAmount,
    required TransactionType transactionType,
    List<CartItem>? products,
    double discount = 0,
    DateTime? dateTime,
  }) {
    return PaymentDataModel(
      paymentType: transactionType == TransactionType.returnTransaction
          ? PaymentTransactionType.returnPayment
          : PaymentTransactionType.salePayment,
      clientSupplier: clientSupplier,
      oldBalance: oldBalance,
      currentOrderAmount: totalAmount,
      products: products,
      discount: discount,
      dateTime: dateTime,
    );
  }

  factory PaymentDataModel.directPayment({
    required ClientSupp? clientSupplier,
    required double oldBalance,
  }) {
    return PaymentDataModel(
      paymentType: PaymentTransactionType.directPayment,
      clientSupplier: clientSupplier,
      oldBalance: oldBalance,
    );
  }

  factory PaymentDataModel.refund({
    required ClientSupp? clientSupplier,
    required double oldBalance,
  }) {
    return PaymentDataModel(
      paymentType: PaymentTransactionType.refund,
      clientSupplier: clientSupplier,
      oldBalance: oldBalance,
    );
  }

  PaymentDataModel copyWith({
    double? oldBalance,
    double? currentOrderAmount,
    double? paymentAmount,
    String? notes,
    List<CartItem>? products,
    double? discount,
    DateTime? dateTime,
  }) {
    return PaymentDataModel(
      paymentType: paymentType,
      clientSupplier: clientSupplier,
      oldBalance: oldBalance ?? this.oldBalance,
      currentOrderAmount: currentOrderAmount ?? this.currentOrderAmount,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      notes: notes ?? this.notes,
      products: products ?? this.products,
      discount: discount ?? this.discount,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
