import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavBarWidget extends StatelessWidget {
  final Color? navBarColor;
  final EdgeInsets? padding;
  final Widget? widget;
  final double borderRadius;

  const CustomBottomNavBarWidget({
    super.key,
    this.navBarColor = Colors.transparent,
    this.padding,
    this.borderRadius = 0,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 30.h),
      decoration: BoxDecoration(
        color: navBarColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
      ),
      child: widget,
    );
  }
}
