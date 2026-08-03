import 'package:flutter/services.dart';

/// Regular expression patterns and input formatters for validation.
abstract final class RegexUtils {
  static bool hasMatch(String input, {required String pattern}) {
    return RegExp(pattern).hasMatch(input);
  }

  /// Allows only numbers (integers) e.g., 12345
  static const String onlyNumbers = r'^\d+$';

  /// Only has a number
  static const String hasANumber = r'[0-9]';

  /// Has at least one uppercase letter
  static const String hasUppercase = r'[A-Z]';

  /// Has at least one special character
  static const String hasSpecialCharacter = r'[!@#$%^&*(),.?":{}|<>]';

  /// Allows numbers with decimals e.g., 4000.0, 423.32
  static const String numbersWithDecimal = r'^\d*\.?\d*$';

  /// Allows alphabets only (uppercase and lowercase)
  static const String onlyAlphabets = r'^[a-zA-Z]+$';

  /// Allows alphanumeric characters (letters and numbers only, no spaces)
  static const String alphanumeric = r'^[a-zA-Z0-9]+$';

  /// Allows alphanumeric with spaces
  static const String alphanumericWithSpaces = r'^[a-zA-Z0-9 ]+$';

  /// Allows alphabets with spaces (no numbers or special chars)
  static const String alphabetsWithSpaces = r'^[a-zA-Z ]+$';

  /// Allows a valid email format
  static const String email = r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'
      "'"
      '*+/=?^_`{|}~-]+@[a-zA-Z0-9]+.[a-zA-Z]+';

  /// Allows a valid phone number (digits only, 8 to 15 digits)
  static const String phoneNumber = r'^\d{8,15}$';

  /// Allows a valid password (min 8 chars, at least one letter and number)
  static const String strongPassword =
      r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$';

  static FilteringTextInputFormatter getNumbersFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(onlyNumbers));
  }

  static FilteringTextInputFormatter getDecimalFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(numbersWithDecimal));
  }
}
