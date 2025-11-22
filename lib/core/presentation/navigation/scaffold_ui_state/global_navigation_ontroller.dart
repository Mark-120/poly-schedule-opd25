import 'package:flutter/material.dart';

class GlobalNavigationController extends ChangeNotifier {
  int _currentIndex = 0;
  final Map<int, GlobalKey<NavigatorState>> _navigatorKeys = {};

  int get currentIndex => _currentIndex;

  void registerNavigatorKey(int index, GlobalKey<NavigatorState> key) {
    _navigatorKeys[index] = key;
  }

  GlobalKey<NavigatorState>? navigatorKeyFor(int index) =>
      _navigatorKeys[index];

  void goToTab(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    notifyListeners();
  }

  Future<void> pushToTab(int index, Route route) async {
    _currentIndex = index;
    notifyListeners();

    final key = _navigatorKeys[index];
    if (key == null) return;

    final ns = key.currentState;
    if (ns != null) {
      ns.push(route);
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ns2 = key.currentState;
      ns2?.push(route);
    });
  }
}
