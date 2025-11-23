import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'core/presentation/navigation/app_navigation.dart';
import 'core/presentation/navigation/scaffold_ui_state/scaffold_ui_state_controller.dart';
import 'core/presentation/uikit/app_text_styles.dart';
import 'core/presentation/uikit_2.0/app_colors.dart';
import 'core/presentation/uikit_2.0/app_themes.dart';
import 'core/services/app_initialization_service.dart';
import 'core/services/last_schedule_service.dart';
import 'data/models/last_schedule.dart';
import 'presentation_2.0/pages/scaffold_ui_wrapper.dart';
import 'presentation_2.0/state_managers/schedule_bloc/schedule_bloc.dart';
import 'presentation_2.0/state_managers/search_screen_bloc/search_bloc.dart';
import 'service_locator.dart';

void main() async {
  await AppInitializationService.initializeApplication();
  final lastSchedule = await sl<LastScheduleService>().load();

  runApp(
    Provider<LastScheduleService>(
      create: (context) => sl<LastScheduleService>(),
      child: MainApp(lastSchedule: lastSchedule),
    ),
  );
}

class MainApp extends StatelessWidget {
  final LastSchedule? lastSchedule;

  const MainApp({super.key, this.lastSchedule});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(NewAppColors.Ryae);
    return MaterialApp(
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppNavigation.onGenerateRoute,
      routes: AppNavigation.routes,
      builder: (context, child) {
        return AppTextStylesProvider(
          styles: AppTextStyles(context),
          child: child!,
        );
      },
      home: _buildHomeScreen(),
    );
  }

  Widget _buildHomeScreen() {
    return ChangeNotifierProvider<ScaffoldUiStateController>(
      create: (_) => ScaffoldUiStateController(),
      child: ScaffoldUiWrapper(),
    );
  }
}
