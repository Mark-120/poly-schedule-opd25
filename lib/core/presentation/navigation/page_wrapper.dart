import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'scaffold_ui_state/scaffold_ui_state_controller.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  final ScaffoldUiStateController controller = ScaffoldUiStateController();

  PageWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScaffoldUiStateController>(
      create: (_) => controller,
      child: child,
    );
  }
}
