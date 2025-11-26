import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnectivity {
  static Future<bool> hasInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    // No Wi-Fi or mobile network
    if (connectivityResult.any((x) => x != ConnectivityResult.none)) {
      return false;
    }

    // Try reaching a real internet address
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
