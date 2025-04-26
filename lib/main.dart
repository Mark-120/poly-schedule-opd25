import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

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
      home: ScheduleScreen(),
    );
  }
}
