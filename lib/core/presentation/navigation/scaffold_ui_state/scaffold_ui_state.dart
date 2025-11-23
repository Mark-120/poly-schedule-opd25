import 'package:flutter/material.dart';

import 'value.dart';

class ScaffoldUiState {
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  const ScaffoldUiState({this.appBar, this.floatingActionButton});

  @override
  String toString() {
    return 'ScaffoldUiState(appBar: $appBar, floatingActionButton: $floatingActionButton)';
  }

  ScaffoldUiState mergeWith(ScaffoldUiState newState) {
    return ScaffoldUiState(
      appBar: newState.appBar ?? appBar,
      floatingActionButton:
          newState.floatingActionButton ?? floatingActionButton,
    );
  }

  ScaffoldUiState copyWith({
    Value<PreferredSizeWidget?>? appBar,
    Value<Widget?>? floatingActionButton,
  }) {
    return ScaffoldUiState(
      appBar: appBar?.isSet == true ? appBar!.value : this.appBar,
      floatingActionButton:
          floatingActionButton?.isSet == true
              ? floatingActionButton!.value
              : this.floatingActionButton,
    );
  }
}
