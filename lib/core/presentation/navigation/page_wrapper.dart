import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'scaffold_ui_state/scaffold_ui_state_controller.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  final ScaffoldUiStateController controller = ScaffoldUiStateController();

  PageWrapper({super.key, required this.child, required this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScaffoldUiStateController>.value(
      value: controller,
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(builder: (ctx) => child, settings: settings);
        },
      ),
    );
  }
}
