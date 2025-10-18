import 'package:equatable/equatable.dart';

import '../../core/exception/local_exception.dart';
import 'group.dart';
import 'room.dart';
import 'teacher.dart';

class EntityId extends Equatable {
  final Object value; // can be GroupId / TeacherId / RoomId

  const EntityId.group(GroupId group) : value = group;
  const EntityId.room(RoomId room) : value = room;
  const EntityId.teacher(TeacherId teacher) : value = teacher;

  GroupId get asGroup => value as GroupId;
  RoomId get asRoom => value as RoomId;
  TeacherId get asTeacher => value as TeacherId;

  bool get isGroup => value is GroupId;
  bool get isRoom => value is RoomId;
  bool get isTeacher => value is TeacherId;

  @override
  List<Object?> get props => [value];

  @override
  String toString() {
    return 'EntityId(value: $value, type: ${isGroup ? "group" : (isRoom ? "room" : "teacher")})';
  }

  String toShortString() {
    return '$value,${isGroup ? "g" : (isRoom ? "r" : "t")}';
  }

  factory EntityId.parseShort(String string) {
    var strings = string.split(',');
    switch (strings[1]) {
      case 'g':
        return EntityId.group(GroupId(int.parse(strings[0])));
      case 'r':
        return EntityId.room(RoomId.parse(strings[0]));
      case 't':
        return EntityId.teacher(TeacherId(int.parse(strings[0])));
      default:
        throw LocalException('Incorrect format of EntityId');
    }
  }
}
