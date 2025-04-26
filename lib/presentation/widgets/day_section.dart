import 'package:flutter/material.dart';
import 'package:poly_scheduler/domain/entities/schedule/lesson.dart';
import 'package:poly_scheduler/presentation/widgets/class_card.dart';

Widget daySection(String date, String day, List<Lesson> classes) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      color: Color(0xFFCFE3CF),
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
              Text(
                date,
                style: const TextStyle(
                  color: Color(0xFF244029),
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                day,
                style: const TextStyle(color: Color(0xFF5F7863), fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...List.generate(classes.length, (index) {
            final lesson = classes[index];
            final teachers = lesson.teachers
                .map((teacher) => teacher.fullName)
                .join(', ');
            final auditories = lesson.auditories
                .map((room) => '${room.name} ауд., ${room.building.name}')
                .join(';');
            return classCard(
              lesson.start,
              lesson.end,
              lesson.subject,
              teachers,
              lesson.type,
              auditories,
            );
          }),
        ],
      ),
    ),
  );
}
