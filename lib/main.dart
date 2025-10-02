import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/logger.dart';
import 'core/presentation/bloc_observer.dart';
import 'core/presentation/uikit/app_strings.dart';
import 'core/presentation/uikit/app_text_styles.dart';
import 'core/presentation/uikit/app_theme.dart';
import 'data/models/last_schedule.dart';
import 'domain/repositories/last_schedule_repository.dart';
import 'domain/usecases/last_schedule_usecases/save_last_schedule.dart';
import 'presentation/pages/empty_schedule_screen.dart';
import 'presentation/pages/schedule_screen.dart';
import 'service_locator.dart' as di;
import 'service_locator.dart';

void main() async {
  await initializeDateFormatting('ru', null);
  await di.init();
  Bloc.observer = BlocLogger(sl<AppLogger>());

  final lastSchedule = await GetLastSchedule(sl<LastScheduleRepository>())();

  runApp(MainApp(lastSchedule: lastSchedule));
}

class MainApp extends StatelessWidget {
  final LastSchedule? lastSchedule;

  const MainApp({super.key, this.lastSchedule});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
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
    if (lastSchedule == null) return EmptyScheduleScreen();
    return ScheduleScreen(
      id: lastSchedule!.id,
      dayTime: DateTime.now(),
      bottomTitle:
          (lastSchedule!.id.isTeacher)
              ? AppStrings.fullNameToAbbreviation(lastSchedule!.title)
              : lastSchedule!.title,
    );
  }
}
