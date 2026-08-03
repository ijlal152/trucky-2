import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/core/utils/extensions.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/client_supplier/bloc/client_supp_models.dart';
import 'package:trucky/presentation/widgets/custom_divider.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// List of client/supplier transactions with balance-per-item display.
class TransactionListWidget<T extends ClientSuppTxn> extends StatelessWidget {
  const TransactionListWidget({
    super.key,
    required this.list,
    this.scrollController,
    required this.iconBuilder,
    required this.amountColorBuilder,
    this.onTapTxn,
  });

  final List<T> list;
  final ScrollController? scrollController;
  final Widget Function(int index, T item) iconBuilder;
  final Color Function(int index, T item) amountColorBuilder;
  final void Function(int)? onTapTxn;

  @override
  Widget build(BuildContext context) {
    return list.isEmpty
        ? Center(
            child: LabelWidget(
              text: 'No Record Found',
              textSize: 16.sp,
              fontWeight: FontWeight.w600,
              textColor: Colors.black,
            ),
          )
        : ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: list.length,
            controller: scrollController,
            itemBuilder: (context, index) {
              final item = list[index];
              return GestureDetector(
                onTap: onTapTxn != null ? () => onTapTxn!(index) : null,
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 10.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            iconBuilder(index, item),
                            8.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LabelWidget(
                                  text: item.txnData.showMonthNameWithTime(
                                    false,
                                  ),
                                  textSize: 16.sp,
                                  fontFamily: FontConstants.inter,
                                  fontWeight: FontWeight.normal,
                                ),
                                LabelWidget(
                                  text:
                                      'Balance: ${NumberFormater.formatStringToCurrency(ClientSuppTxn.calculateBalanceAtIndex(transactions: list.cast<ClientSuppTxn>(), index: index).toString())}',
                                  textSize: 11.sp,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: FontConstants.inter,
                                  textColor: const Color.fromRGBO(
                                    92,
                                    97,
                                    111,
                                    1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              LabelWidget(
                                text: NumberFormater.formatStringToCurrency(
                                  item.amount,
                                ),
                                textSize: 16.sp,
                                fontFamily: FontConstants.interSemiBold,
                                textColor: amountColorBuilder(index, item),
                              ),
                              LabelWidget(
                                text: item.paymentType,
                                textSize: 11.sp,
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
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: dividerWidget(),
              );
            },
          ).paddingOnly(top: 10.h);
  }
}
