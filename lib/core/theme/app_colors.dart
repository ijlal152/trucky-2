import 'package:flutter/material.dart';

/// Central color palette for the app.
abstract final class AppColors {
  static const Color primary = Color(0xFF00695C);
  static const Color secondary = Color(0xFFFFB300);
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  static const Color buttonBgColor = Color.fromRGBO(43, 136, 216, 1);
  static const Color hintTextColor = Color.fromRGBO(54, 61, 78, 1);
  static const Color blueTextColor = Color.fromRGBO(0, 147, 185, 1);

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFE8EBF5), Color(0xFFFBFCFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
