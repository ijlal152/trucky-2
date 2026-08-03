import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/theme/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String btnTitle;
  final double btnHeight;
  final double btnWidth;
  final Color btnBgColor;
  final Color btnTitleColor;
  final FontWeight fontWeight;
  final double fontSize;
  final bool enableShadow;
  final bool isDisabled;
  final VoidCallback onTap;
  final IconData? icon;
  final double iconSize;
  final Color? iconColor;

  const CustomElevatedButton({
    super.key,
    this.btnTitle = '',
    this.btnHeight = 56,
    this.btnWidth = 360,
    this.fontSize = 17,
    this.btnTitleColor = Colors.white,
    this.fontWeight = FontWeight.w600,
    this.isDisabled = false,
    this.btnBgColor = AppColors.buttonBgColor,
    this.enableShadow = true,
    required this.onTap,
    this.icon,
    this.iconSize = 24,
    this.iconColor,
  });

  const CustomElevatedButton.withIcon({
    super.key,
    required this.btnTitle,
    required this.onTap,
    required IconData this.icon,
    this.iconSize = 24,
    this.iconColor,
    this.btnHeight = 56,
    this.btnWidth = 360,
    this.fontSize = 17,
    this.btnTitleColor = Colors.white,
    this.fontWeight = FontWeight.w600,
    this.isDisabled = false,
    this.btnBgColor = AppColors.buttonBgColor,
    this.enableShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      height: btnHeight.h,
      width: btnWidth.w,
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          foregroundColor: Colors.white,
          backgroundColor: btnBgColor,
          fixedSize: Size(btnWidth.w, btnHeight.h),
          elevation: enableShadow ? 4 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.r),
          ),
        ),
        onPressed: !isDisabled ? onTap : null,
        child: icon == null
            ? Text(
                btnTitle,
                style: TextStyle(
                  fontSize: fontSize.sp,
                  fontWeight: fontWeight,
                  color: btnTitleColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: iconSize, color: iconColor ?? btnTitleColor),
                  const SizedBox(width: 8),
                  Text(
                    btnTitle,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: btnTitleColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
