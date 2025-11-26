import 'package:equatable/equatable.dart';
import 'entity.dart';
import 'entity_id.dart';

class GroupId extends EntityId with EquatableMixin {
  final int id;

  const GroupId(this.id);

  @override
  List<Object?> get props => [id];
  factory GroupId.parse(String string) {
    return GroupId(int.parse(string));
  }
  @override
  String toString() {
    return '$id';
  }

  @override
  String toUniqueString() {
    return 'g$id';
  }
}

abstract class Group extends ScheduleEntity with EquatableMixin {
  final GroupId id;
  final String name;
  const Group({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  @override
  GroupId getId() {
    return id;
  }
}
