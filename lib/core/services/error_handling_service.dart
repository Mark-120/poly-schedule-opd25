import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class ErrorHandlingService {
  static void handleError(BuildContext context, String message) {
    FirebaseCrashlytics.instance.recordError(
      message,
      StackTrace.current,
      fatal: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    });
  }
}
