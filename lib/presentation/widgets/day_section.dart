import 'package:flutter/material.dart';

import '../../core/presentation/app_text_styles.dart';
import '../../core/presentation/app_strings.dart';
import '../../core/presentation/theme_extension.dart';
import '../../domain/entities/schedule/lesson.dart';
import '../../presentation/widgets/class_card.dart';

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
                  return classCard(
                    lesson.start,
                    lesson.end,
                    lesson.subject,
                    teachers,
                    lesson.type,
                    auditories,
                    context,
                  );
                }),
              ),
        ],
      ),
    ),
  );
}
