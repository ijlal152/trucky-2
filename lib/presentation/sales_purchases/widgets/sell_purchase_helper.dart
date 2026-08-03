import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_bloc.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_models.dart';
import 'package:trucky/presentation/widgets/custom_elevated_button.dart';
import 'package:trucky/presentation/widgets/custom_floating_btn.dart';

/// Bottom bar with barcode / add-product buttons and the "Next" action that
/// builds a [PaymentDataModel] and moves on to the payment screen.
class SellPurchaseHelper extends StatelessWidget {
  const SellPurchaseHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomFloatingBtn(
          imgPath: AppAssets.svgs.barCodeScannerSvg,
          onTap: () {},
        ),
        BlocBuilder<SalePurchaseBloc, dynamic>(
          builder: (context, _) {
            return CustomElevatedButton(
              btnWidth: 200.w,
              btnTitle: 'Next',
              onTap: () {
                final state = context.read<SalePurchaseBloc>().state;
                final clientSupp =
                    context.read<ClientSuppBloc>().state;
                final oldBalance =
                    ClientSuppTxn.calculateCurrentBalance(
                  clientSupplierId: state.selectedClientSupp?.id ?? -1,
                  allTransactions: clientSupp.currentTxnList,
                );
                final paymentData = PaymentDataModel.fromTransaction(
                  clientSupplier: state.selectedClientSupp,
                  oldBalance: oldBalance,
                  totalAmount: state.totalAfterDiscount,
                  products: state.selectedProdList,
                  transactionType: state.transactionType,
                  discount: state.discountAmount,
                );
                context.push(
                  RoutePaths.paymentDetails,
                  extra: paymentData,
                );
              },
            );
          },
        ),
        CustomFloatingBtn(
          onTap: () => context.push(RoutePaths.addProduct),
        ),
      ],
    );
  }
}
