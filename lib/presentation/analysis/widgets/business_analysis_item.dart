import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trucky/core/constants/app_assets.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/core/utils/number_formater.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// A title/amount/percentage block used on the analysis sections.
Widget businessAnalysisItem({
  required String title,
  required String amount,
  required bool isProfit,
  required String percentage,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      LabelWidget(
        text: title,
        textSize: 14.sp,
        fontWeight: FontWeight.normal,
      ),
      5.verticalSpace,
      SizedBox(
        width: 150.w,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: LabelWidget(
            text: NumberFormater.formatAmount(amount),
            textSize: 20.sp,
            maxLines: 1,
            fontFamily: FontConstants.interSemiBold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      5.verticalSpace,
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            isProfit
                ? AppAssets.svgs.profitIndicatorSvg
                : AppAssets.svgs.lossIndicatorSvg,
            width: 20.w,
            height: 20.h,
          ),
          2.horizontalSpace,
          LabelWidget(
            text: isProfit ? '+$percentage%' : '-$percentage%',
            textSize: 14.sp,
            textColor: isProfit ? Colors.green : Colors.red,
          ),
        ],
      ),
    ],
  );
}

/// A title/amount block with no percentage, used in working capital.
Widget workingCapitalItem({required String title, required String amount}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      LabelWidget(
        text: title,
        textSize: 14.sp,
        fontWeight: FontWeight.normal,
      ),
      SizedBox(height: 5.h),
      SizedBox(
        width: 150.w,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: LabelWidget(
            text: amount,
            textSize: 20.sp,
            maxLines: 1,
            fontFamily: FontConstants.interSemiBold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ],
  );
}