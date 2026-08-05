import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/presentation/widgets/label_widget.dart';

/// Confirmation dialog used for destructive actions (e.g. logout).
void showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required String message,
  required VoidCallback yesOnTap,
  required VoidCallback cancelOnTap,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: LabelWidget(text: title),
      content: LabelWidget(text: message),
      actions: [
        TextButton(
          onPressed: cancelOnTap,
          child: const LabelWidget(
            text: 'No',
            textSize: 16,
            textColor: Colors.blue,
          ),
        ),
        TextButton(
          onPressed: yesOnTap,
          child: const LabelWidget(
            text: 'Yes',
            textSize: 16,
            textColor: Colors.blue,
          ),
        ),
      ],
    ),
  );
}