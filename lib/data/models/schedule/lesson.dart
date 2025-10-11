import '../../../domain/entities/group.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/entities/schedule/lesson.dart';

import '../../../domain/entities/teacher.dart';
import '../group.dart';
import '../room.dart';
import '../teacher.dart';

class LessonModel extends Lesson {
  const LessonModel({
    required super.subject,
    required super.type,
    required super.typeAbbr,
    required super.start,
    required super.end,
    required super.groups,
    required super.auditories,
    required super.teachers,
    required super.webinarUrl,
    required super.lmsUrl,
  });

  factory LessonModel.fromLesson(Lesson lesson) {
    return LessonModel(
      subject: lesson.subject,
      type: lesson.type,
      typeAbbr: lesson.typeAbbr,
      start: lesson.start,
      end: lesson.end,
      groups: List<Group>.from(lesson.groups),
      teachers: List<Teacher>.from(lesson.teachers),
      auditories: List<Room>.from(lesson.auditories),
      webinarUrl: lesson.webinarUrl,
      lmsUrl: lesson.lmsUrl,
    );
  }

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      subject: json['subject'],
      type: json['typeObj']['name'],
      typeAbbr: json['typeObj']['abbr'],
      start: json['time_start'],
      end: json['time_end'],
      groups:
          (json['groups'] as List<dynamic>)
              .map((lesson) => GroupModel.fromJson(lesson))
              .toList(),
      teachers:
          ((json['teachers'] ?? []) as List<dynamic>)
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
  LessonModel copyWith({
    List<Room>? auditories,
    List<Group>? groups,
    List<Teacher>? teachers,
  }) {
    return LessonModel(
      auditories: auditories ?? this.auditories,
      groups: groups ?? this.groups,
      teachers: teachers ?? this.teachers,
      subject: subject,
      type: type,
      typeAbbr: typeAbbr,
      start: start,
      end: end,
      webinarUrl: webinarUrl,
      lmsUrl: lmsUrl,
    );
  }
}
