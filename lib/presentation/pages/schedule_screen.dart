import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poly_scheduler/core/date_formater.dart';
import 'package:poly_scheduler/data/models/schedule/week.dart';
import 'package:poly_scheduler/domain/entities/schedule/week.dart';

import '../../core/moked_data/moked_week_json.dart';
import '../widgets/class_card.dart';
import '../widgets/day_section.dart';



class ScheduleScreen extends StatelessWidget {

  final Week week = WeekModel.fromJson(jsonDecode(MokedWeekJson.mokedWeekJson));

  ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            Text(week.isOdd ? 'четная' : 'нечетная', style: TextStyle(color: Colors.white, fontSize: 14)),
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
        itemBuilder:(context, index) {
          final day = week.days[index];
          return daySection(DateFormater.showDateToUser(day.date) , DateFormater.showWeekdayToUser(day.date), day.lessons);
        },
        itemCount: week.days.length,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) => SizedBox(height: 16,),
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
