import 'package:flutter/widgets.dart';

import '../../configs/scaffold_ui_state.dart';

class ScaffoldUiStateController extends ChangeNotifier {
  ScaffoldUiState _state = ScaffoldUiState();

  ScaffoldUiState get state => _state;

  void update(ScaffoldUiState newState) {
    _state = newState;
    notifyListeners();
  }
}
