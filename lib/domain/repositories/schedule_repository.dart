import '../entities/schedule/week.dart';
import '../entities/group.dart';
import '../entities/teacher.dart';
import '../entities/room.dart';
import '../entities/building.dart';

abstract class ScheduleRepository {
  const ScheduleRepository();
  Future<List<Teacher>> findTeachers(String query);
  Future<List<Group>> findGroups(String query);

  Future<List<Building>> getAllBuildings();
  Future<List<Room>> getAllRoomsOfBuilding(int buildingId);

  Future<Week> getScheduleByTeacher(TeacherId teacherId, DateTime dayTime);
  Future<Week> getScheduleByGroup(GroupId groupId, DateTime dayTime);
  Future<Week> getScheduleByRoom(RoomId roomId, DateTime dayTime);

  Future<void> invalidateScheduleByTeacher(
    TeacherId teacherId,
    DateTime dayTime,
  );
  Future<void> invalidateScheduleByGroup(GroupId groupId, DateTime dayTime);
  Future<void> invalidateScheduleByRoom(RoomId roomId, DateTime dayTime);
}
