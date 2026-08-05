import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Password strength checklist shown on the edit-password screen.
class PasswordValidationWidget extends StatelessWidget {
  final bool isValidPasswordLength;
  final bool hasUppercaseSymbol;
  final bool hasANumber;

  const PasswordValidationWidget({
    super.key,
    this.isValidPasswordLength = false,
    this.hasUppercaseSymbol = false,
    this.hasANumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ValidationRow(
          isValid: isValidPasswordLength,
          text: 'Has at least 8 characters',
        ),
        _ValidationRow(
          isValid: hasUppercaseSymbol,
          text: 'Has an upper case letter or symbol',
        ),
        _ValidationRow(isValid: hasANumber, text: 'Has a number'),
      ],
    );
  }
}

class _ValidationRow extends StatelessWidget {
  final bool isValid;
  final String text;

  const _ValidationRow({required this.isValid, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          Icons.check,
          color: isValid
              ? const Color.fromRGBO(0, 177, 103, 1)
              : const Color.fromRGBO(167, 170, 178, 1),
        ),
        8.horizontalSpace,
        LabelWidget(
          text: text,
          fontWeight: FontWeight.normal,
          textSize: 13.sp,
          textColor: const Color.fromRGBO(92, 97, 111, 1),
        ),
      ],
    );
  }
}