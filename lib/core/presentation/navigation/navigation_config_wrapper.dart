import 'package:flutter/material.dart';

class NavigationConfigWrapper extends StatelessWidget {
  final Widget? appBar;
  final Widget? floatingActionButton;
  final Widget child;

  const NavigationConfigWrapper({
    super.key,
    this.appBar,
    this.floatingActionButton,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
