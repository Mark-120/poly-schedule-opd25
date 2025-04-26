import '../group.dart';
import '../room.dart';
import '../teacher.dart';

class Lesson {
  final String subject;
  final String type;
  final String typeAbbr;
  final String start;
  final String end;
  final List<Group> groups;
  final List<Teacher> teachers;
  final List<Room> auditories;
  final String webinarUrl;
  final String lmsUrl;

  const Lesson({
    required this.subject,
    required this.typeAbbr,
    required this.type,
    required this.start,
    required this.end,
    required this.groups,
    required this.auditories,
    required this.teachers,
    required this.webinarUrl,
    required this.lmsUrl,
  });
}
