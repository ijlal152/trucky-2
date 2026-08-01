import 'package:flutter/material.dart';
import 'package:trucky/core/constants/app_constants.dart';
import 'package:trucky/core/router/app_router.dart';
import 'package:trucky/core/theme/app_theme.dart';

/// Root application widget.
class TruckyApp extends StatelessWidget {
  const TruckyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.light,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
