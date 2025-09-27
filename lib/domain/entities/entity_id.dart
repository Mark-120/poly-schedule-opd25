import 'group.dart';
import 'room.dart';
import 'teacher.dart';

class EntityId {
  final Object value; // can be GroupId / TeacherId / RoomId

  EntityId.group(GroupId group) : value = group;
  EntityId.teacher(TeacherId teacher) : value = teacher;
  EntityId.room(RoomId room) : value = room;

  bool get isGroup => value is GroupId;
  bool get isTeacher => value is TeacherId;
  bool get isRoom => value is RoomId;

  GroupId get asGroup => value as GroupId;
  TeacherId get asTeacher => value as TeacherId;
  RoomId get asRoom => value as RoomId;
}
