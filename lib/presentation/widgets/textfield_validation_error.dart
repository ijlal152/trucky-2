import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Validation error message shown below a form field.
Widget textFieldValidationError({
  required bool isValid,
  required String requiredParameter,
}) {
  return !isValid
      ? Align(
          alignment: Alignment.centerLeft,
          child: LabelWidget(
            text: '* $requiredParameter',
            textColor: Colors.red,
            textSize: 12.sp,
            fontFamily: FontConstants.roboto,
            fontWeight: FontWeight.normal,
          ).paddingSymmetric(horizontal: 10.w),
        )
      : const SizedBox.shrink();
}
