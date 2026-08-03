import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Icon + label item used in transaction bottom sheets.
GestureDetector btmSheetPaymentTypeItem({
  required String icon,
  required String itemName,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(icon, height: 50.h),
        5.verticalSpace,
        LabelWidget(text: itemName),
      ],
    ),
  );
}
