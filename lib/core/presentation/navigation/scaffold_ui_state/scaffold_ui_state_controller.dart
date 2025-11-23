import 'package:flutter/widgets.dart';

import 'scaffold_ui_state.dart';
import 'value.dart';

class ScaffoldUiStateController extends ChangeNotifier {
  ScaffoldUiState _state = ScaffoldUiState();

  ScaffoldUiState get state => _state;

  void update(ScaffoldUiState newState) {
    _state = newState;
    notifyListeners();
  }

  void add(ScaffoldUiState newState) {
    _state = _state.mergeWith(newState);
    notifyListeners();
  }

  void clearFAB() {
    _state = _state.copyWith(floatingActionButton: Value.set(null));
    notifyListeners();
  }
}
