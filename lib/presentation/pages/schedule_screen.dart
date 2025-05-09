import 'dart:convert';
import 'package:flutter/material.dart';

import '../../data/models/schedule/week.dart';
import '../../domain/entities/schedule/day.dart';
import '../../domain/entities/schedule/week.dart';
import '../../core/date_formater.dart';
import '../../core/mocked_data/mocked_week_json.dart';
import '../../core/presentation/app_text_styles.dart';
import '../../core/presentation/constants.dart';
import '../../core/presentation/theme_extension.dart';
import '../widgets/day_section.dart';

class ScheduleScreen extends StatelessWidget {
  final Week week = WeekModel.fromJson(
    jsonDecode(MockedWeekEntity.mockedWeekJson),
  );

  ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyles = AppTextStylesProvider.of(context);

    final Map<DateTime, Day> daysWithSchedule = {
      for (var e in week.days) e.date: e,
    };
    final daysToShow = List.generate(
      6,
      (i) => week.dateStart.add(Duration(days: i)),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: context.appTheme.iconColor),
          onPressed: () {},
        ),
        title: Column(
          children: [
            Text(
              '${DateFormater.showShortDateToUser(week.dateStart)} - ${DateFormater.showShortDateToUser(week.dateEnd)}',
              style: textStyles.titleAppbar,
            ),
            Text(
              week.isOdd ? AppStrings.oddWeek : AppStrings.evenWeek,
              style: textStyles.subtitleAppbar,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: context.appTheme.iconColor,
            ),
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
            context,
          );
        },
        itemCount: daysToShow.length,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) => SizedBox(height: 16),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.settings_outlined,
                color: context.appTheme.iconColor,
              ),
              iconSize: 28,
              onPressed: () {},
            ),
            Text('5130903/30003', style: textStyles.titleBottomAppBar),
            IconButton(
              icon: Icon(
                Icons.star_outline_outlined,
                color: context.appTheme.iconColor,
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
