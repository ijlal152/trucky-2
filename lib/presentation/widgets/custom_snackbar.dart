import 'package:flutter/material.dart';
import 'package:trucky/core/router/navigator_key.dart';

var animationDuration = const Duration(milliseconds: 800);

/// Shows app-wide snackbar messages.
class MySnackbarMessage {
  static void showErrorMessage({String? title, String? message}) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Message'),
        backgroundColor: Colors.red,
        duration: animationDuration,
      ),
    );
  }

  static void showSuccessMessage({String? title, String? message}) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Message'),
        backgroundColor: Colors.green,
        duration: animationDuration,
      ),
    );
  }
}
