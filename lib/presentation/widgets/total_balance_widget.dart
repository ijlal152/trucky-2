import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Shows a title and a large balance amount (e.g. "Total Stock Value").
class TotalBalanceWidget extends StatelessWidget {
  final String title;
  final String balance;
  final bool hideBalance;
  final String currency;

  const TotalBalanceWidget({
    super.key,
    required this.balance,
    required this.title,
    this.hideBalance = true,
    this.currency = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LabelWidget(
          textSize: 17.sp,
          text: title,
          textColor: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        Text.rich(
          TextSpan(
            text: balance,
            style: TextStyle(
              fontSize: balance.length > 20 ? 25.sp : 36.sp,
              color: Colors.white,
              fontFamily: FontConstants.interBold,
              fontWeight: FontWeight.w600,
            ),
            children: [
              const TextSpan(text: ' '),
              TextSpan(
                text: hideBalance ? '' : currency,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: FontConstants.inter,
                ),
              ),
            ],
          ),
          maxLines: 3,
          textAlign: TextAlign.center,
        ).paddingOnly(left: 20.w, right: 20.w, top: 10.h),
      ],
    );
  }
}
