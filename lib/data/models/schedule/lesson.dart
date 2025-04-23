import '../../../domain/entities/schedule/lesson.dart';

import '../group.dart';
import '../room.dart';
import '../teacher.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required super.subject,
    required super.abbr,
    required super.type,
    required super.start,
    required super.end,
    required super.groups,
    required super.auditories,
    required super.teachers,
    required super.webinarUrl,
    required super.lmsUrl,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      subject: json['subject'],
      abbr: json['abbr'],
      type: json['typeObj']['name'],
      start: json['time_start'],
      end: json['time_end'],
      groups:
          (json['groups'] as List<dynamic>)
              .map((lesson) => GroupModel.fromJson(lesson))
              .toList(),
      teachers:
          (json['teachers'] as List<dynamic>)
              .map((lesson) => TeacherModel.fromJson(lesson))
              .toList(),
      auditories:
          (json['auditories'] as List<dynamic>)
              .map((lesson) => RoomModel.fromJson(lesson))
              .toList(),
      webinarUrl: json['webinar_url'] ?? '',
      lmsUrl: json['lms_url'] ?? '',
    );
  }
}
