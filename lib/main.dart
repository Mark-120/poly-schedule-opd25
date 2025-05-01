import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:poly_scheduler/presentation/pages/search_screen.dart';
import 'package:poly_scheduler/presentation/search_screen_type.dart';

void main() async {
  await initializeDateFormatting('ru', null);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchScreen(searchScreenType: SearchScreenType.teachers),
    );
  }
}
