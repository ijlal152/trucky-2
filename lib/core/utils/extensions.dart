import 'package:intl/intl.dart';

/// String helpers (initials, phone).
extension StringExtensions on String {
  /// First letters of the first two words, uppercased.
  String get initials {
    final List<String> nameParts = trim().split(' ');

    String initials = '';
    if (nameParts.isNotEmpty) {
      initials += nameParts[0][0];
    }
    if (nameParts.length > 1) {
      initials += nameParts[1][0];
    }

    return initials.toUpperCase();
  }

  /// Removes the leading zero from the phone number if it exists.
  String removeLeadingZero() {
    if (startsWith('0')) {
      return substring(1);
    }
    return this;
  }
}

/// Date formatting helpers.
extension CustomDateTimeFormat on DateTime {
  /// Formats as "28 Sep 2024, 11:52 PM" (or date only).
  String showMonthNameWithTime([bool showTime = true]) {
    final dateFormat = DateFormat('d MMM yyyy');
    final timeFormat = DateFormat('hh:mm a');
    if (showTime) {
      return '${dateFormat.format(this)}, ${timeFormat.format(this)}';
    }
    return dateFormat.format(this);
  }
}
