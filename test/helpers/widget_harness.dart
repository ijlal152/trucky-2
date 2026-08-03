import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps [child] with the same initialization the app uses
/// ([ScreenUtilInit] + [MaterialApp]) so widgets that depend on
/// `flutter_screenutil` can be pumped in isolation.
Future<void> pumpWithApp(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(412, 892),
      minTextAdapt: true,
      fontSizeResolver: FontSizeResolvers.height,
      child: child,
      builder: (context, child) => MaterialApp(
        home: Scaffold(body: child),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
