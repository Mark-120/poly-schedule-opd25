import 'package:flutter/material.dart';

import '../../core/presentation/uikit/app_strings.dart';
import '../../core/presentation/uikit_2.0/app_text_styles.dart';
import '../../domain/entities/schedule/lesson.dart';
import 'schedule_class_card.dart';

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
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                  final lesson = classes[index];
                  final teachers = lesson.teachers
                      .map((teacher) => teacher.fullName)
                      .join(', ');
                  final auditories = lesson.auditories
                      .map(
                        (room) => ' ${room.building.abbr}, ${room.name} ауд.',
                      )
                      .join(';');
                  final abbrType =
                      lesson.type.length < 10 ? lesson.type : lesson.typeAbbr;
                  final type = lesson.type;
                  final groups = lesson.groups.map((e) => e.name).toList();
                  return Column(
                    children: [
                      Divider(),
                      ScheduleClassCard(
                        timeStart: lesson.start,
                        timeEnd: lesson.end,
                        title: lesson.subject,
                        teacher: teachers,
                        abbrType: abbrType,
                        type: type,
                        location: auditories,
                        groups: groups,
                        sdoLink: lesson.lmsUrl,
                      ),
                    ],
                  );
                }),
              ),
        ],
      ),
    );
  }
}
