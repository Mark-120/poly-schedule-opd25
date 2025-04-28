import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poly_scheduler/core/date_formater.dart';
import 'package:poly_scheduler/data/models/schedule/week.dart';
import 'package:poly_scheduler/domain/entities/schedule/week.dart';

import '../../core/mocked_data/mocked_week_json.dart';
import '../../domain/entities/schedule/day.dart';
import '../widgets/day_section.dart';

class ScheduleScreen extends StatelessWidget {
  final Week week = WeekModel.fromJson(
    jsonDecode(MockedWeekEntity.mockedWeekJson),
  );

  ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<DateTime, Day> daysWithSchedule = {
      for (var e in week.days) e.date: e,
    };
    final daysToShow = List.generate(
      6,
      (i) => week.dateStart.add(Duration(days: i)),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4FA24E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {},
        ),
        title: Column(
          children: [
            Text(
              '${DateFormater.showShortDateToUser(week.dateStart)} - ${DateFormater.showShortDateToUser(week.dateEnd)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              week.isOdd ? 'четная' : 'нечетная',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          final date = daysToShow[index];
          return daySection(
            DateFormater.showDateToUser(date),
            DateFormater.showWeekdayToUser(date),
            daysWithSchedule[date]?.lessons,
          );
        },
        itemCount: daysToShow.length,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) => SizedBox(height: 16),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF4FA24E),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.white),
              iconSize: 28,
              onPressed: () {},
            ),
            const Text(
              '5130903/30003',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.star_outline_outlined,
                color: Colors.white,
              ),
              iconSize: 28,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
