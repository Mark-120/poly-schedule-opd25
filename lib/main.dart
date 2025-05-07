import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:poly_scheduler/core/presentation/app_theme.dart';
import 'package:poly_scheduler/presentation/pages/schedule_screen.dart';
import 'package:poly_scheduler/presentation/pages/settings_screen.dart';

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
      home: Builder(
        builder: (context) {
          final brightness = MediaQuery.of(context).platformBrightness;
          return AppTextStylesProvider(
            styles: AppTextStyles(brightness),
            child: ScheduleScreen(),
          );
        },
      ),
    );
  }
}
