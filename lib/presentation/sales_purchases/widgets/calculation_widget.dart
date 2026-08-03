import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/route_paths.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_bloc.dart';
import 'package:trucky/presentation/sales_purchases/bloc/sale_purchase_event.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Items/qty summary with the discount line and running total.
class CalculationWidget extends StatelessWidget {
  const CalculationWidget({super.key, this.isInvoice = false});

  final bool isInvoice;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalePurchaseBloc, dynamic>(
      builder: (context, _) {
        final state = context.read<SalePurchaseBloc>().state;
        final hasDiscount = state.discountCash > 0 ||
            state.discountPercentage > 0;

        return Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: LabelWidget(
                text:
                    '${state.selectedProdList.length} Items (Qty : ${state.totalQuantity.toStringAsFixed(0)})',
                textColor: const Color.fromRGBO(54, 61, 78, 1),
                fontWeight: FontWeight.w500,
                textSize: 13.sp,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isInvoice) 30.verticalSpace,
                  if (hasDiscount) _discountWidget(context, state),
                  if (!hasDiscount && !isInvoice)
                    InkWell(
                      onTap: () => context.push(RoutePaths.setDiscount),
                      child: LabelWidget(
                        text: 'Add Discount',
                        textColor: const Color.fromRGBO(255, 124, 111, 1),
                        fontWeight: FontWeight.w600,
                        textSize: 16.sp,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (!isInvoice) 20.verticalSpace,
                  LabelWidget(
                    text:
                        'TOTAL : ${NumberFormater.formatAmount(state.totalAfterDiscount.toString(), showCurrency: true)}',
                    textColor: const Color.fromRGBO(54, 61, 78, 1),
                    fontWeight: FontWeight.w600,
                    textSize: 18.sp,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ).marginOnly(top: 10.h, bottom: !isInvoice ? 30.h : 10.h);
      },
    );
  }

  Widget _discountWidget(BuildContext context, dynamic state) {
    final discountText =
        '(${state.discountPercentage.toStringAsFixed(2)}%) '
        '${NumberFormater.formatAmount(state.discountAmount.toString(), showCurrency: true)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        LabelWidget(
          text:
              'Subtotal : ${NumberFormater.formatAmount(state.subtotal.toString(), showCurrency: true)}',
          textSize: 16.sp,
        ),
        10.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!isInvoice)
              InkWell(
                onTap: () => context
                    .read<SalePurchaseBloc>()
                    .add(const ClearDiscountEvent()),
                child: SvgPicture.asset(AppAssets.svgs.closeSvg),
              ),
            15.horizontalSpace,
            LabelWidget(
              text: 'Discount : $discountText',
              textSize: 16.sp,
              textColor: const Color.fromRGBO(255, 124, 111, 1),
            ),
          ],
        ),
      ],
    ).marginSymmetric(vertical: 10.h);
  }
}
