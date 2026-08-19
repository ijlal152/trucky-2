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
    _persist(context, data, _newTransactionId());
  }

  /// Writes the rows for [data] under [transactionId].
  ///
  /// A Sale/Purchase/Return writes one main transaction, one [ProductDetail]
  /// row per cart line, and a settlement transaction (`Payment`/`Refund`)
  /// only when a non-zero payment was entered.
  static void _persist(
    BuildContext context,
    PaymentDataModel data,
    String transactionId,
  ) {
    _persistWithBlocs(
      context.read<ClientSuppBloc>(),
      context.read<ProductBloc>(),
      data,
      transactionId,
    );
  }

  static void _persistWithBlocs(
    ClientSuppBloc clientSuppBloc,
    ProductBloc productBloc,
    PaymentDataModel data,
    String transactionId,
  ) {
    final isOrder =
        data.paymentType == PaymentTransactionType.salePayment ||
        data.paymentType == PaymentTransactionType.returnPayment;

    if (!isOrder) {
      clientSuppBloc.add(
        AddTransactionEvent(txn: _buildMainTxn(data, transactionId)),
      );
      return;
    }

    final mainTxn = _buildMainTxn(data, transactionId);
    clientSuppBloc.add(AddTransactionEvent(txn: mainTxn));
    if (mainTxn.products.isNotEmpty) {
      productBloc.add(AddProductDetailsEvent(details: mainTxn.products));
    }
    if (data.paymentAmount > 0) {
      clientSuppBloc.add(
        AddTransactionEvent(txn: _buildSettlementTxn(data, transactionId)),
      );
    }
  }

  /// Replaces an existing transaction (edit-mode).
  ///
  /// The transaction keeps its original [transactionId] and [ClientSuppTxn.txnData],
  /// so the edited Sale/Purchase/Return replaces the old rows in place rather
  /// than recording a brand-new sale at a new ledger position.
  ///
  /// Bloc handlers run concurrently, so the removal is awaited (via its emitted
  /// state) before the replacement rows are written; otherwise the late removal
  /// emission could clobber the just-added rows.
  static Future<void> editTransaction(
    BuildContext context,
    PaymentDataModel data,
    ClientSuppTxn oldTxn,
  ) async {
    final clientSuppBloc = context.read<ClientSuppBloc>();
    final productBloc = context.read<ProductBloc>();

    final txnId = oldTxn.transactionId;
    final isOrder =
        data.paymentType == PaymentTransactionType.salePayment ||
        data.paymentType == PaymentTransactionType.returnPayment;

    final removeDone = clientSuppBloc.stream.firstWhere(
      (s) => !s.allTransactions.any((t) => t.transactionId == txnId),
    );
    clientSuppBloc.add(RemoveTransactionsEvent(transactionId: txnId));
    if (isOrder) {
      final productRemoveDone = productBloc.stream.firstWhere(
        (s) => !s.productDetailsList.any((d) => d.transactionId == txnId),
      );
      productBloc.add(
        RemoveProductDetailsEvent(transactionId: txnId),
      );
      await productRemoveDone;
    }
    await removeDone;
    _persistWithBlocs(
      clientSuppBloc,
      productBloc,
      data.copyWith(dateTime: oldTxn.txnData),
      txnId,
    );
  }
}
