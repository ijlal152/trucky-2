import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trucky/core/constants/app_assets.dart';

/// Reusable transparent app bar used across the products UI.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? titleWidget;
  final List<Widget>? actionWidgets;
  final double height;
  final bool automaticallyImplyLeading;
  final Color? leadingIconColor;
  final Color? titleColor;
  final Color? backgroundColor;
  final bool centerTitle;
  final VoidCallback? leadingOnTap;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.titleWidget,
    this.actionWidgets,
    this.leadingIconColor,
    this.height = 70,
    this.centerTitle = true,
    this.automaticallyImplyLeading = true,
    this.backgroundColor = Colors.transparent,
    this.leadingOnTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(70.h),
      child: AppBar(
        centerTitle: centerTitle,
        backgroundColor: backgroundColor,
        elevation: 0,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: automaticallyImplyLeading,
        actions: actionWidgets,
        leading: automaticallyImplyLeading
            ? IconButton(
                onPressed: () {
                  if (leadingOnTap != null) {
                    leadingOnTap!();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                icon: SvgPicture.asset(
                  AppAssets.svgs.backBtnSvg,
                  fit: BoxFit.contain,
                  height: 16.h,
                  width: 16.w,
                  colorFilter: ColorFilter.mode(
                    leadingIconColor ?? Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              )
            : null,
        title: titleWidget ?? Text(title, style: TextStyle(color: titleColor)),
        iconTheme: IconThemeData(color: leadingIconColor),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height.h);
}
