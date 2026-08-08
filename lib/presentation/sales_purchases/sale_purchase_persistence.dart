import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_event.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';
import 'package:trucky/presentation/products/bloc/product_event.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_models.dart';

/// Orchestrates persisting a completed transaction across the shared blocs.
///
/// A Sale/Purchase/Return writes:
///   * one main transaction (payment type `Sale`/`Purchase`/`Return`),
///   * one `ProductDetail` row per cart line (adjusting stock),
///   * a settlement transaction (`Payment` for sale/purchase, `Refund` for a
///     return).
/// A direct Payment/Refund writes a single transaction.
abstract final class SalePurchasePersistence {
  static String _newTransactionId() =>
      'txn-${DateTime.now().microsecondsSinceEpoch}';

  static ClientSuppTxn _buildMainTxn(
    PaymentDataModel data,
    String transactionId,
  ) {
    final entity = data.clientSupplier;
    final now = data.dateTime ?? DateTime.now();
    final products = (data.products ?? const <CartItem>[]).map((item) {
      return ProductDetail(
        productId: item.product.id ?? 0,
        sourceName: entity?.name,
        sourceType: entity?.role,
        purchasePrice: item.product.purchasePrice,
        sellingPrice: item.product.sellingPrice,
        quantity: item.quantity,
        paymentType: data.paymentTypeString,
        createdAt: now,
        transactionId: transactionId,
        quantityPerPackage: item.quantityPerPackage,
      );
    }).toList();

    final isOrder =
        data.paymentType == PaymentTransactionType.salePayment ||
        data.paymentType == PaymentTransactionType.returnPayment;

    return ClientSuppTxn(
      clientSuppId: entity?.id ?? -1,
      transactionId: transactionId,
      clientSupplierName: entity?.name ?? '',
      role: entity?.role ?? '',
      txnData: now,
      // Direct payments/refunds persist the paid amount; orders persist the
      // order total (matching the old app's _addClientTxn behaviour).
      amount: (isOrder ? data.currentOrderAmount : data.paymentAmount)
          .toStringAsFixed(2),
      paymentType: data.paymentTypeString,
      discountAmount: data.discount.toStringAsFixed(2),
      note: data.notes,
      products: products,
    );
  }

  static ClientSuppTxn _buildSettlementTxn(
    PaymentDataModel data,
    String transactionId,
  ) {
    final entity = data.clientSupplier;
    return ClientSuppTxn(
      clientSuppId: entity?.id ?? -1,
      transactionId: transactionId,
      clientSupplierName: entity?.name ?? '',
      role: entity?.role ?? '',
      txnData: data.dateTime ?? DateTime.now(),
      amount: data.paymentAmount.toStringAsFixed(2),
      paymentType: data.paymentType == PaymentTransactionType.returnPayment
          ? 'Refund'
          : 'Payment',
      note: data.notes,
    );
  }

  /// Adds a new transaction (add-mode).
  static void addTransaction(BuildContext context, PaymentDataModel data) {
    final clientSuppBloc = context.read<ClientSuppBloc>();
    final productBloc = context.read<ProductBloc>();

    final isOrder =
        data.paymentType == PaymentTransactionType.salePayment ||
        data.paymentType == PaymentTransactionType.returnPayment;

    if (!isOrder) {
      clientSuppBloc.add(
        AddTransactionEvent(txn: _buildMainTxn(data, _newTransactionId())),
      );
      return;
    }

    final transactionId = _newTransactionId();
    final mainTxn = _buildMainTxn(data, transactionId);
    clientSuppBloc.add(AddTransactionEvent(txn: mainTxn));
    if (mainTxn.products.isNotEmpty) {
      productBloc.add(AddProductDetailsEvent(details: mainTxn.products));
    }
    clientSuppBloc.add(
      AddTransactionEvent(txn: _buildSettlementTxn(data, transactionId)),
    );
  }

  /// Replaces an existing transaction (edit-mode).
  static void editTransaction(
    BuildContext context,
    PaymentDataModel data,
    ClientSuppTxn oldTxn,
  ) {
    final clientSuppBloc = context.read<ClientSuppBloc>();
    final productBloc = context.read<ProductBloc>();

    final isOrder =
        data.paymentType == PaymentTransactionType.salePayment ||
        data.paymentType == PaymentTransactionType.returnPayment;

    clientSuppBloc.add(
      RemoveTransactionsEvent(transactionId: oldTxn.transactionId),
    );
    if (isOrder) {
      productBloc.add(
        RemoveProductDetailsEvent(transactionId: oldTxn.transactionId),
      );
    }
    addTransaction(context, data);
  }
}
