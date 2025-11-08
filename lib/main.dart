import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/presentation/navigation/app_navigation.dart';
import 'core/presentation/uikit/app_strings.dart';
import 'core/presentation/uikit/app_text_styles.dart';
// import 'core/presentation/uikit/app_theme.dart';
import 'core/presentation/uikit_2.0/app_colors.dart';
import 'core/presentation/uikit_2.0/app_themes.dart';
import 'core/services/app_initialization_service.dart';
import 'core/services/last_schedule_service.dart';
import 'data/models/last_schedule.dart';
import 'presentation/pages/empty_schedule_screen.dart';
import 'presentation/pages/schedule_screen.dart';
import 'presentation_2.0/pages/navigation_app_wrapper.dart';
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
    final theme = AppTheme(NewAppColors.Ifksit);
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

  // Widget _buildHomeScreen() {
  //   if (lastSchedule == null) return EmptyScheduleScreen();
  //   return ScheduleScreen(
  //     id: lastSchedule!.id,
  //     dayTime: DateTime.now(),
  //     bottomTitle:
  //         (lastSchedule!.id.isTeacher)
  //             ? AppStrings.fullNameToAbbreviation(lastSchedule!.title)
  //             : lastSchedule!.title,
  //   );
  // }

  Widget _buildHomeScreen() => NavigationAppWrapper();
}
