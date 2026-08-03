import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/constants/font_constants.dart';
import 'package:trucky/core/utils/widget_extensions.dart';

/// Plus/minus quantity control with a centered editable number field.
class QuantityControlWidget extends StatelessWidget {
  const QuantityControlWidget({
    super.key,
    this.controller,
    this.incQty,
    this.decQty,
  });

  final TextEditingController? controller;
  final VoidCallback? incQty;
  final VoidCallback? decQty;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65.h,
      child: Row(
        children: [
          plusMinusBtn(onTap: decQty ?? () {}, icon: Icons.remove),
          Expanded(
            child: CustomNumberField(
              leftDottedMargin: 20,
              rightDottedMargin: 20,
              controller: controller,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
              keyboardType: TextInputType.number,
            ),
          ),
          plusMinusBtn(onTap: incQty ?? () {}, icon: Icons.add),
        ],
      ).marginSymmetric(horizontal: 50.w),
    );
  }
}

GestureDetector plusMinusBtn({
  required VoidCallback onTap,
  required IconData icon,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 36.h,
      width: 36.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black),
      ),
      child: Center(child: Icon(icon)),
    ),
  );
}

/// Large centered numeric input with a dotted underline.
class CustomNumberField extends StatelessWidget {
  const CustomNumberField({
    super.key,
    this.controller,
    this.keyboardType =
        const TextInputType.numberWithOptions(decimal: true),
    this.inputFormatters,
    this.onChanged,
    this.fontSize = 32,
    this.leftDottedMargin = 60,
    this.rightDottedMargin = 60,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final double fontSize;
  final double leftDottedMargin;
  final double rightDottedMargin;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            TextFormField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: keyboardType,
              onChanged: onChanged,
              inputFormatters: inputFormatters ??
                  [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
              decoration: const InputDecoration(
                hintText: '0',
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: fontSize.sp,
                fontFamily: FontConstants.inter,
                color: const Color.fromRGBO(4, 12, 34, 1),
                fontWeight: FontWeight.w600,
              ),
            ),
            Positioned(
              bottom: 0,
              left: leftDottedMargin.w,
              right: rightDottedMargin.w,
              child: const CustomPaint(painter: DottedBorderPainter()),
            ),
          ],
        ),
      ],
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  const DottedBorderPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromRGBO(167, 170, 178, 1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    var startX = 0.0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
