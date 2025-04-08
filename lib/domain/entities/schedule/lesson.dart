import 'package:equatable/equatable.dart';

import '../group.dart';
import '../room.dart';
import '../teacher.dart';

class Lesson extends Equatable {
  final String subject;
  final String abbr;
  final String type;
  final String start;
  final String end;
  final List<Group> groups;
  final List<Teacher> teachers;
  final List<Room> auditories;
  final String webinarUrl;
  final String lmsUrl;

  const Lesson({
    required this.subject,
    required this.abbr,
    required this.type,
    required this.start,
    required this.end,
    required this.groups,
    required this.auditories,
    required this.teachers,
    required this.webinarUrl,
    required this.lmsUrl,
  });

  @override
  List<Object?> get props => [
    subject,
    abbr,
    type,
    start,
    end,
    groups,
    auditories,
    teachers,
    webinarUrl,
    lmsUrl,
  ];
}
