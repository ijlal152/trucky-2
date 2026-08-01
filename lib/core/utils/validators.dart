/// Shared input validation helpers used by form fields.
abstract final class Validators {
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;

    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!pattern.hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? minLength(String? value, {int min = 6}) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;

    if (value!.trim().length < min) {
      return 'Must be at least $min characters';
    }
    return null;
  }
}
