import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/presentation/navigation/app_navigation.dart';
import 'core/presentation/navigation/scaffold_ui_state/scaffold_ui_state_controller.dart';
import 'core/presentation/uikit/app_text_styles.dart';
import 'core/presentation/uikit_2.0/app_colors.dart';
import 'core/presentation/uikit_2.0/app_themes.dart';
import 'core/services/app_initialization_service.dart';
import 'core/services/last_featured_service.dart';
import 'domain/entities/featured.dart';
import 'presentation_2.0/pages/scaffold_ui_wrapper.dart';
import 'service_locator.dart';

void main() async {
  await AppInitializationService.initializeApplication();
  final lastSchedule = await sl<LastFeaturedService>().load();

  runApp(
    Provider<LastFeaturedService>(
      create: (context) => sl<LastFeaturedService>(),
      child: MainApp(lastFeatured: lastSchedule),
    ),
  );
}

class MainApp extends StatelessWidget {
  final Featured? lastFeatured;

  const MainApp({super.key, this.lastFeatured});

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
      child: ScaffoldUiWrapper(lastFeatured: lastFeatured),
    );
  }
}
