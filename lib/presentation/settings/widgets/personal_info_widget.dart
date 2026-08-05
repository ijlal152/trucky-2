import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/utils/widget_extensions.dart';
import 'package:trucky/presentation/widgets/custom_elevated_button.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// A personal-information row with an optional edit button.
class PersonalInfoWidget extends StatelessWidget {
  final String headingText;
  final String personalInfoData;
  final bool isEditEnabled;
  final VoidCallback onTap;

  const PersonalInfoWidget({
    super.key,
    required this.headingText,
    required this.personalInfoData,
    this.isEditEnabled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LabelWidget(
                text: headingText,
                textSize: 14.sp,
                fontWeight: FontWeight.bold,
                textColor: const Color.fromRGBO(54, 61, 78, 1),
              ),
              5.verticalSpace,
              LabelWidget(
                text: personalInfoData,
                textSize: 17.sp,
                fontWeight: FontWeight.w600,
                textColor: Colors.black,
              ),
            ],
          ),
        ),
        if (isEditEnabled)
          Flexible(
            child: CustomElevatedButton(
              onTap: onTap,
              btnTitle: 'Edit',
              fontSize: 15.sp,
              btnHeight: 40.h,
              btnWidth: 76.w,
              btnBgColor: Colors.white,
              enableShadow: false,
              btnTitleColor: Colors.black,
            ),
          ),
      ],
    ).paddingOnly(left: 20.w, right: 20.w, top: 10.h, bottom: 10.h);
  }
}