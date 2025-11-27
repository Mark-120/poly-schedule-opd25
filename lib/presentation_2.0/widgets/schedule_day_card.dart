import 'package:flutter/material.dart';

import '../../core/presentation/uikit/app_strings.dart';
import '../../core/presentation/uikit_2.0/app_text_styles.dart';
import '../../domain/entities/schedule/lesson.dart';
import 'schedule_class_section.dart';

class ScheduleDayCard extends StatefulWidget {
  final String date;
  final String day;
  final List<Lesson>? classes;

  const ScheduleDayCard({
    super.key,
    required this.date,
    required this.day,
    this.classes,
  });

  @override
  State<ScheduleDayCard> createState() => _ScheduleDayCardState();
}

class _ScheduleDayCardState extends State<ScheduleDayCard> {
  @override
  Widget build(BuildContext context) {
    final classes = widget.classes;
    final textStyles = Theme.of(context).extension<AppTypography>()!;
    return Card(
      elevation: 0.1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.date, style: textStyles.dayTitle),
                Text(widget.day, style: textStyles.dayTitle),
              ],
            ),
            classes == null || classes.isEmpty
                ? SizedBox(
                  height: 40,
                  child: Column(
                    children: [
                      Divider(),
                      Center(
                        child: Text(
                          AppStrings.noLessonInfoMessage,
                          style: textStyles.subjectTitle,
                        ),
                      ),
                    ],
                  ),
                )
                : Column(
                  children: List.generate(classes.length, (index) {
                    return Column(
                      children: [
                        Divider(),
                        ScheduleClassSection(lesson: classes[index]),
                      ],
                    );
                  }),
                ),
          ],
        ),
      ),
    );
  }
}
