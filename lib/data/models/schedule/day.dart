import '../../../domain/entities/schedule/day.dart';
import '../../../domain/entities/schedule/lesson.dart';
import 'lesson.dart';

class DayModel extends Day {
  const DayModel({required super.date, required super.lessons});

  factory DayModel.fromJson(Map<String, dynamic> json) {
    return DayModel(
      date: DateTime.parse(json['date'].replaceAll('.', '-')),
      lessons:
          json['lessons']
              .map<Lesson>((lesson) => LessonModel.fromJson(lesson))
              .toList(),
    );
  }
}
