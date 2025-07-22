import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:poly_scheduler/core/logger.dart';
import 'package:poly_scheduler/core/presentation/bloc_observer.dart';
import 'package:poly_scheduler/core/presentation/uikit/app_strings.dart';
import 'package:poly_scheduler/data/models/last_schedule.dart';
import 'package:poly_scheduler/domain/entities/room.dart';

import 'domain/repositories/last_schedule_repository.dart';
import 'domain/usecases/last_schedule_usecases/save_last_schedule.dart';
import 'presentation/pages/empty_schedule_screen.dart';
import 'core/presentation/uikit/app_theme.dart';
import 'core/presentation/uikit/app_text_styles.dart';
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

    switch (lastSchedule!.type) {
      case 'group':
        return ScheduleScreen.group(
          groupId: int.parse(lastSchedule!.id),
          dayTime: DateTime.now(),
          bottomTitle: lastSchedule!.title,
        );
      case 'teacher':
        return ScheduleScreen.teacher(
          teacherId: int.parse(lastSchedule!.id),
          dayTime: DateTime.now(),
          bottomTitle: AppStrings.fullNameToAbbreviation(lastSchedule!.title),
        );
      case 'room':
        return ScheduleScreen.room(
          roomId: RoomId.parse(lastSchedule!.id),
          dayTime: DateTime.now(),
          bottomTitle: lastSchedule!.title,
        );
      default:
        return EmptyScheduleScreen();
    }
  }
}
