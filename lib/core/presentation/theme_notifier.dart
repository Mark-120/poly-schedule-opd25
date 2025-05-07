import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  Brightness _brightness = Brightness.light;

  Brightness get brightness => _brightness;

  void toggleTheme() {
    _brightness =
        _brightness == Brightness.light ? Brightness.dark : Brightness.light;
    notifyListeners();
  }
}
