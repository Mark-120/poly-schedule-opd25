import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:poly_scheduler/presentation/pages/building_search_screen.dart';
import 'package:poly_scheduler/presentation/pages/class_search_screen.dart';
import 'package:poly_scheduler/presentation/pages/featured_screen.dart';

import 'core/presentation/app_theme.dart';
import 'core/presentation/app_text_styles.dart';

void main() async {
  await initializeDateFormatting('ru', null);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: Builder(
        builder: (context) {
          return AppTextStylesProvider(
            styles: AppTextStyles(context),
            child: ClassSearchScreen(),
          );
        },
      ),
    );
  }
}
