import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/enums.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_event.dart';
import 'package:trucky/presentation/sales_purchases/widgets/calculation_widget.dart';
import 'package:trucky/presentation/sales_purchases/widgets/cart_list.dart';
import 'package:trucky/presentation/sales_purchases/widgets/sell_purchase_helper.dart';
import 'package:trucky/presentation/widgets/custom_app_bar.dart';
import 'package:trucky/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:trucky/presentation/widgets/custom_scaffold.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// The sale/purchase cart: edit quantities, apply discounts, continue.
class SellPurchaseCartPage extends StatelessWidget {
  const SellPurchaseCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalePurchaseBloc, dynamic>(
      builder: (context, _) {
        final state = context.read<SalePurchaseBloc>().state;
        final isReturn =
            state.transactionType == TransactionType.returnTransaction;
        final baseTitle = isReturn
            ? 'Return'
            : (state.entityType == EntityType.supplier ? 'Purchase' : 'Sale');
        final title = state.operationType == OperationType.edit
            ? 'Edit $baseTitle'
            : baseTitle;
        final selectedName =
            state.selectedClientSupp?.name ?? 'Client/Supp Name';

        return CustomScaffold(
          backgroundColor: const Color.fromRGBO(255, 251, 254, 0),
          appBar: CustomAppBar(
            title: title,
            centerTitle: false,
            titleColor: Colors.black,
            leadingIconColor: Colors.black,
            leadingOnTap: () => _confirmCancel(context),
            actionWidgets: [_selectedUserNameChip(context, selectedName)],
          ),
          body: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(child: CartList(cartItems: state.selectedProdList)),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavBarWidget(
            navBarColor: Colors.white,
            borderRadius: 22.r,
            widget: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [CalculationWidget(), SellPurchaseHelper()],
            ).paddingSymmetric(horizontal: 20.w),
          ),
        );
      },
    );
  }

  void _confirmCancel(BuildContext context) {
    final state = context.read<SalePurchaseBloc>().state;
    final returnToDashboard = state.returnToDashboard;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Warning!'),
        content: Text(
          state.operationType == OperationType.edit
              ? 'Do you really want to cancel editing this transaction?'
              : 'Do you really want to cancel the sale?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SalePurchaseBloc>().add(
                const ResetSalePurchaseDataEvent(),
              );
              Navigator.pop(dialogContext);
              context.go(
                returnToDashboard
                    ? RoutePaths.clientSuppDashboard
                    : RoutePaths.salePurchase,
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  Widget _selectedUserNameChip(BuildContext context, String name) {
    return InkWell(
      onTap: () => context.push(RoutePaths.chooseClientSupp),
      child: Container(
        height: 35.h,
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: LabelWidget(
            text: name,
            textColor: Colors.black,
            fontWeight: FontWeight.w500,
            textSize: 16.sp,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ).paddingSymmetric(horizontal: 8.w),
        ),
      ),
    );
  }
}
