import 'package:flutter/material.dart';

class ScaffoldUiState {
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  const ScaffoldUiState({this.appBar, this.floatingActionButton});

  @override
  String toString() {
    return 'UiConfig(appBar: $appBar, floatingActionButton: $floatingActionButton)';
  }
}
