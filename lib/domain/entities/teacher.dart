import 'package:equatable/equatable.dart';

import 'entity.dart';
import 'entity_id.dart';

class TeacherId extends EntityId with EquatableMixin {
  final int id;

  const TeacherId(this.id);

  @override
  List<Object?> get props => [id];
  factory TeacherId.parse(String string) {
    return TeacherId(int.parse(string));
  }
  @override
  String toString() {
    return '$id';
  }

  @override
  String toUniqueString() {
    return 't${toString()}';
  }
}

abstract class Teacher extends ScheduleEntity with EquatableMixin {
  final TeacherId id;
  final String fullName;
  const Teacher({required this.id, required this.fullName});

  @override
  List<Object?> get props => [id, fullName];

  @override
  TeacherId getId() {
    return id;
  }
}
