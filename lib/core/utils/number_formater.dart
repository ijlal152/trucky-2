import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Formats numbers and amounts for display in the UI.
abstract final class NumberFormater {
  static String formatStringToCurrency(
    String amount, {
    bool showCurrency = true,
    bool showFullAmount = true,
  }) {
    final value = double.tryParse(amount) ?? 0.0;

    final NumberFormat formatter = NumberFormat('#,##0.00');
    String formattedString = formatter.format(value);

    String result = showCurrency
        ? formattedString
        : formattedString.replaceAll(RegExp(r'\d'), '*');

    if (!showFullAmount && result.length > 8) {
      return '${result.substring(0, 8)}...';
    }

    return result;
  }

  static String formatAmount(
    String amount, {
    bool showCurrency = false,
    String currency = '',
    bool showAmount = true,
  }) {
    final value = double.tryParse(amount) ?? 0.0;

    final NumberFormat formatter = NumberFormat('#,##0.00');
    String formattedAmount = formatter.format(value.abs());

    if (value < 0) {
      formattedAmount = '-$formattedAmount';
    }

    if (!showAmount) {
      return '*******';
    }

    if (showCurrency) {
      formattedAmount = '$formattedAmount $currency';
    }

    return formattedAmount;
  }

  static Color getTextColorBasedOnAmount(double amount,
      {bool isSupplier = false}) {
    if (isSupplier) {
      return amount > 0
          ? const Color.fromRGBO(0, 177, 103, 1)
          : const Color.fromRGBO(255, 124, 111, 1);
    } else {
      return amount > 0
          ? const Color.fromRGBO(255, 124, 111, 1)
          : const Color.fromRGBO(0, 177, 103, 1);
    }
  }
}
