import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/core/utils/extensions.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Lists the recent Sale/Purchase/Return transactions.
class SalesPurchaseCommonList extends StatelessWidget {
  const SalesPurchaseCommonList({
    super.key,
    required this.list,
    this.showBalance = true,
    this.onTap,
  });

  final List<ClientSuppTxn> list;
  final bool showBalance;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    return list.isNotEmpty
        ? ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: list.length,
            itemBuilder: (context, index) {
              final txn = list[index];
              return InkWell(
                onTap: onTap != null ? () => onTap!(index) : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 48.h,
                            width: 48.h,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(246, 247, 248, 1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: LabelWidget(
                                text: txn.clientSupplierName.initials,
                                textSize: 16.sp,
                                fontFamily: FontConstants.interSemiBold,
                              ),
                            ),
                          ),
                          10.horizontalSpace,
                          Flexible(
                            child: SizedBox(
                              width: 200.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LabelWidget(
                                    text: txn.clientSupplierName,
                                    textSize: 16.sp,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  SizedBox(height: 5.h),
                                  LabelWidget(
                                    text:
                                        txn.txnData.showMonthNameWithTime(),
                                    textSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    textColor: const Color.fromRGBO(
                                      92,
                                      97,
                                      111,
                                      1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 150.w,
                      child: LabelWidget(
                        text: NumberFormater.formatAmount(
                          txn.amount,
                          showAmount: showBalance,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.right,
                        textSize: 16.sp,
                        fontFamily: FontConstants.interSemiBold,
                        textColor: showBalance == false
                            ? const Color.fromRGBO(4, 12, 34, 1)
                            : _amountColor(txn.paymentType),
                      ),
                    ),
                  ],
                ).paddingSymmetric(horizontal: 15.w, vertical: 10.h),
              );
            },
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: dividerWidget(),
            ),
          ).paddingOnly(top: 10.h)
        : const Center(child: LabelWidget(text: 'No Transaction Found'));
  }

  Color _amountColor(String paymentType) {
    const Map<String, Color> colors = {
      'Initial Stock': Color.fromRGBO(0, 177, 103, 1), // Green
      'Sale': Color.fromRGBO(255, 124, 111, 1), // Red
      'Payment': Color.fromRGBO(0, 177, 103, 1), // Green
      'Return': Color.fromRGBO(43, 136, 216, 1), // Blue
    };
    return colors[paymentType] ?? const Color.fromRGBO(43, 136, 216, 1);
  }
}
