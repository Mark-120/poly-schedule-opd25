import 'package:flutter/material.dart';

import '../../core/presentation/uikit/app_text_styles.dart';
import '../../core/presentation/uikit/app_strings.dart';
import '../../core/presentation/uikit/theme_extension.dart';
import '../../domain/entities/schedule/lesson.dart';
import 'expandable_class_card.dart';

Widget daySection(
  String date,
  String day,
  List<Lesson>? classes,
  BuildContext context,
) {
  final textStyles = AppTextStylesProvider.of(context);

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      color: context.appTheme.firstLayerCardBackgroundColor,
    ),
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
    child: SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: textStyles.title),
              Text(day, style: textStyles.subtitleDaySection),
            ],
          ),
          const SizedBox(height: 10),
          classes == null || classes.isEmpty
              ? SizedBox(
                height: 69,
                child: Center(
                  child: Text(
                    AppStrings.noLessonInfoMessage,
                    style: textStyles.noLessonsMessage,
                  ),
                ),
              )
              : Column(
                children: List.generate(classes.length, (index) {
                  final lesson = classes[index];
                  final teachers = lesson.teachers
                      .map((teacher) => teacher.fullName)
                      .join(', ');
                  final auditories = lesson.auditories
                      .map((room) => '${room.name} ауд., ${room.building.abbr}')
                      .join(';');
                  final abbrType =
                      lesson.type.length < 10 ? lesson.type : lesson.typeAbbr;
                  final type = lesson.type;
                  final groups = lesson.groups.map((e) => e.name).toList();
                  return ExpandableClassCard(
                    timeStart: lesson.start,
                    timeEnd: lesson.end,
                    title: lesson.subject,
                    teacher: teachers,
                    abbrType: abbrType,
                    type: type,
                    location: auditories,
                    groups: groups,
                    sdoLink: lesson.lmsUrl,
                  );
                }),
              ),
        ],
      ),
    ),
  );
}
