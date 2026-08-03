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
}
