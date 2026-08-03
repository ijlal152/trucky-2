import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/core/utils/extensions.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Simple list tile for Clients/Suppliers list rows.
class SimpleListTile extends StatelessWidget {
  final String name;
  final DateTime? dateOfTransaction;
  final String balance;
  final bool showBalance;
  final VoidCallback? onTap;

  const SimpleListTile({
    super.key,
    this.name = '',
    this.dateOfTransaction,
    this.balance = '0',
    this.showBalance = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                      text: name.initials,
                      textSize: 16.sp,
                      fontFamily: FontConstants.interSemiBold,
                    ),
                  ),
                ),
                10.horizontalSpace,
                Flexible(
                  child: SizedBox(
                    width: 250.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelWidget(
                          text: name,
                          textSize: 16.sp,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 5.h),
                        LabelWidget(
                          text: dateOfTransaction?.showMonthNameWithTime() ?? '',
                          textSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          textColor: const Color.fromRGBO(92, 97, 111, 1),
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
              text: NumberFormater.formatAmount(balance, showAmount: showBalance),
              maxLines: 2,
              textAlign: TextAlign.right,
              textSize: 16.sp,
              fontFamily: FontConstants.interSemiBold,
              textColor: !showBalance
                  ? const Color.fromRGBO(4, 12, 34, 1)
                  : NumberFormater.getTextColorBasedOnAmount(
                      double.parse(balance),
                    ),
            ),
          ),
        ],
      ).paddingSymmetric(horizontal: 15.w, vertical: 10.h),
    );
  }
}
