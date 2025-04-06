import 'package:equatable/equatable.dart';
import 'package:poly_scheduler/domain/entities/faculty.dart';

enum GroupType { common, evening, distance }

enum GroupKind {
  bachelor,
  master,
  specialist,
  graduate,
  sve, // Secondary vocational education
}

class Group extends Equatable {
  final int id;
  final String name;
  final GroupType type;
  final GroupKind kind;
  final int level;
  final int year;
  final Faculty faculty;
  const Group({
    required this.id,
    required this.name,
    required this.type,
    required this.kind,
    required this.level,
    required this.year,
    required this.faculty,
  });

  @override
  List<Object?> get props => [id, name, type, kind, level, year, faculty];
}
