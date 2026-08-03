import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Option row used inside bottom sheets (e.g. pick image from gallery/camera).
GestureDetector imagePickerOption({
  required String img,
  required String option,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(232, 235, 245, 1),
        border: Border.all(color: Colors.black.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(img, height: 20.h),
          10.horizontalSpace,
          LabelWidget(text: option, textSize: 16.sp),
        ],
      ),
    ),
  );
}
