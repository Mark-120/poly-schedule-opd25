import 'package:flutter/material.dart';

class ErrorHandlingService {
  static void handleError(BuildContext context, String message) {
    _reportError();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    });
  }

  static void _reportError() {
    //TODO: implement error report with Yandex AppMetrica
  }
}
