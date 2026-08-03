import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trucky/core/router/navigator_key.dart';

/// Shows a bottom sheet with rounded top corners.
Future<void> bottomSheetWidget({required Widget bottomSheetWidget}) {
  return showModalBottomSheet<void>(
    context: navigatorKey.currentContext!,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.only(top: 8.h, left: 20.w, right: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: bottomSheetWidget,
      );
    },
  );
}
