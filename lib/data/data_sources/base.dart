import '../../domain/entities/room.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/building.dart';
import '../../domain/entities/schedule/week.dart';

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

abstract class ScheduleDataSource {
  Future<Week> getSchedule(EntityId id, DateTime dayTime);
  Future<void> invalidateSchedule(EntityId id, DateTime dayTime);
}

abstract class FetchDataSource {
  Future<List<Teacher>> findTeachers(String query);
  Future<List<Group>> findGroups(String query);

  Future<List<Building>> getAllBuildings();
  Future<List<Room>> getAllRoomsOfBuilding(int buildingId);
}

class PassThroughSource extends ScheduleDataSource {
  final ScheduleDataSource prevDataSource;
  PassThroughSource({required this.prevDataSource});

  @override
  Future<Week> getSchedule(EntityId id, DateTime dayTime) =>
      prevDataSource.getSchedule(id, dayTime);

  @override
  Future<void> invalidateSchedule(EntityId id, DateTime dayTime) =>
      prevDataSource.invalidateSchedule(id, dayTime);
}
