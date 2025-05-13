import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/presentation/app_theme.dart';
import 'core/presentation/app_text_styles.dart';
import 'presentation/pages/schedule_screen.dart';
import 'presentation/state_managers/schedule_screen_bloc/schedule_bloc.dart';
import 'service_locator.dart';
import 'service_locator.dart' as di;

void main() async {
  await initializeDateFormatting('ru', null);
  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => sl<ScheduleBloc>())],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        builder: (context, child) {
          return AppTextStylesProvider(
            styles: AppTextStyles(context),
            child: child!,
          );
        },
        home: ScheduleScreen.group(groupId: 40461, dayTime: DateTime.now()),
      ),
    );
  }
}
