import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';
import 'package:trucky/presentation/products/bloc/product_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_event.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_models.dart';

/// Shared transaction tap-to-edit dispatch, used by the client/supplier
/// dashboard and the Sales/Purchases page.
///
/// Routes to the cart in edit mode (Sale/Return/Purchase) or the payment
/// screen (Payment/Refund); ignores `Initial Balance`. When
/// [returnToDashboard] is true the post-edit navigation returns to the
/// selected client/supplier dashboard.
mixin TransactionEditMixin {
  void onTapToEdit(
    BuildContext context,
    ClientSuppTxn txn, {
    bool returnToDashboard = false,
  }) {
    if (txn.paymentType == 'Initial Balance') return;

    final clientSuppBloc = context.read<ClientSuppBloc>();
    final entity = clientSuppBloc.state.currentEntityList
        .where((e) => e.id == txn.clientSuppId)
        .firstOrNull;
    if (entity == null) return;

    if (txn.paymentType == 'Payment' || txn.paymentType == 'Refund') {
      context.read<SalePurchaseBloc>().add(
        BeginEditPaymentEvent(
          txn: txn,
          clientSupp: entity,
          returnToDashboard: returnToDashboard,
        ),
      );
      context.push(RoutePaths.paymentDetails);
      return;
    }

    final products = context.read<ProductBloc>().state.products;
    final items = txn.products.map((detail) {
      final product = products
          .where((p) => p.id == detail.productId)
          .firstOrNull;
      return CartItem(
        product:
            product ??
            Product(
              id: detail.productId,
              productName: detail.sourceName ?? '',
              purchasePrice: detail.purchasePrice,
              sellingPrice: detail.sellingPrice,
              availableStock: detail.quantity,
            ),
        quantity: detail.quantity.toInt(),
        unitPrice: clientSuppBloc.state.entityType == EntityType.supplier
            ? detail.purchasePrice
            : detail.sellingPrice,
        quantityPerPackage: detail.quantityPerPackage,
      );
    }).toList();

    context.read<SalePurchaseBloc>().add(
      BeginEditCartEvent(
        txn: txn,
        clientSupp: entity,
        items: items,
        returnToDashboard: returnToDashboard,
      ),
    );
    context.push(RoutePaths.sellPurchaseCart);
  }
}
