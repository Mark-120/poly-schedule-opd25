import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';

class ErrorHandlingService {
  static void handleError(BuildContext context, String message) {
    AppMetrica.reportError(
      message: message,
      errorDescription: AppMetricaErrorDescription(StackTrace.current),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    });
  }
}
