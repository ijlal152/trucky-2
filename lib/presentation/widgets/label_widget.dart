import 'package:flutter/material.dart';

/// Lightweight styled text widget used across the app.
class LabelWidget extends StatelessWidget {
  final String text;
  final double textSize;
  final Color textColor;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final TextDirection? textDirection;
  final int? maxLines;
  final String? fontFamily;
  final TextOverflow? overflow;

  const LabelWidget({
    super.key,
    this.text = '',
    this.fontWeight = FontWeight.w600,
    this.textAlign = TextAlign.left,
    this.textColor = const Color.fromRGBO(4, 12, 34, 1),
    this.textSize = 14,
    this.maxLines,
    this.overflow,
    this.fontFamily,
    this.textDirection = TextDirection.ltr,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: textSize,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        color: textColor,
      ),
    );
  }
}
