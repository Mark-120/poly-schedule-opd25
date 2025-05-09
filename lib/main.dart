import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/presentation/app_theme.dart';
import 'core/presentation/app_text_styles.dart';
import 'presentation/pages/schedule_screen.dart';

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
      builder: (context, child) {
        return AppTextStylesProvider(
          styles: AppTextStyles(context),
          child: child!,
        );
      },
      home: ScheduleScreen(),
    );
  }
}
