import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/theme/app_colors.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// "text ... Click here" prompt used at the bottom of forms.
class AlreadyHaveAnAccountWidget extends StatelessWidget {
  final String btnText;
  final String text;
  final VoidCallback onTap;

  const AlreadyHaveAnAccountWidget({
    super.key,
    required this.btnText,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LabelWidget(
          text: text,
          fontWeight: FontWeight.w600,
          textSize: 15.sp,
          textColor: AppColors.blueTextColor,
        ),
        TextButton(
          onPressed: onTap,
          child: LabelWidget(
            text: btnText,
            fontWeight: FontWeight.w600,
            textSize: 15.sp,
            textColor: AppColors.blueTextColor,
          ),
        ),
      ],
    );
  }
}