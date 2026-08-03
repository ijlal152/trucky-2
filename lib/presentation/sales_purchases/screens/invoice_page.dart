import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/utils/extensions.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_models.dart';
import 'package:trucky/presentation/sales_purchases/widgets/invoice_widgets.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';

/// Final invoice view after a Sale/Purchase/Return completes.
class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentData = GoRouterState.of(context).extra as PaymentDataModel?;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _handleNavigation(context);
      },
      child: CustomScaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Invoice',
          titleColor: Colors.black,
          leadingIconColor: Colors.black,
          leadingOnTap: () => _handleNavigation(context),
          actionWidgets: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InvoiceHeader(
                  name: paymentData?.clientSupplier?.name ?? '',
                  date: (paymentData?.dateTime ?? DateTime.now())
                      .showMonthNameWithTime(true),
                ),
                InvoiceBodyWidget(
                  selectedProducts: paymentData?.products ?? const [],
                  paidAmt:
                      (paymentData?.paymentAmount ?? 0).toStringAsFixed(2),
                  oldBalance: (paymentData?.oldBalance ?? 0).toStringAsFixed(2),
                  newBalance: (paymentData?.newBalance ?? 0).toStringAsFixed(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context) {
    context.go(RoutePaths.salePurchase);
  }
}
