import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DecoratedContainer extends StatelessWidget {
  final Widget? child;
  final double borderRadius;
  final Color color;
  final EdgeInsets? padding;
  final BoxShape shape;
  final double? height;
  final double? width;
  final EdgeInsets margin;
  final bool enableCustomBorder;
  final BorderRadius? customBorderRadius;
  final DecorationImage? decorationImage;
  final Border? border;

  const DecoratedContainer({
    super.key,
    this.color = Colors.white,
    this.padding,
    this.margin = EdgeInsets.zero,
    this.borderRadius = 10,
    this.shape = BoxShape.rectangle,
    this.height,
    this.width,
    this.enableCustomBorder = false,
    this.customBorderRadius,
    this.decorationImage,
    this.border,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        shape: shape,
        image: decorationImage,
        borderRadius: !enableCustomBorder
            ? BorderRadius.circular(borderRadius.r)
            : customBorderRadius,
        border: border,
        color: color,
      ),
      child: child,
    );
  }
}
