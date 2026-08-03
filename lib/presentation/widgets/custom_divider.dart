import 'package:flutter/material.dart';

/// Standard divider used between list items.
Divider dividerWidget() {
  return Divider(color: Colors.black.withValues(alpha: 0.1));
}

/// Small rounded container used as a visual divider (e.g. bottom sheet handle).
class DividerWidget extends StatelessWidget {
  final double width;
  final double height;
  final double paddingV;
  final double paddingH;
  final double radius;
  final Color color;

  const DividerWidget({
    super.key,
    this.width = 48,
    this.paddingV = 0,
    this.paddingH = 0,
    this.height = 4,
    this.radius = 2,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
    );
  }
}
