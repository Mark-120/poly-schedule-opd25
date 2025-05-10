import '../entities/schedule/week.dart';
import '../entities/group.dart';
import '../entities/teacher.dart';
import '../entities/room.dart';
import '../entities/building.dart';

abstract class ScheduleRepository {
  Future<List<Teacher>> findTeachers(String query);
  Future<List<Group>> findGroups(String query);

  Future<List<Building>> getAllBuildings();
  Future<List<Room>> getAllRoomsOfBuilding(int buildingId);

  Future<Week> getScheduleByTeacher(int teacherId, DateTime dayTime);
  Future<Week> getScheduleByGroup(int groupId, DateTime dayTime);
  Future<Week> getScheduleByRoom(RoomId roomId, DateTime dayTime);

  Future<void> invalidateScheduleByTeacher(int teacherId, DateTime dayTime);
  Future<void> invalidateScheduleByGroup(int groupId, DateTime dayTime);
  Future<void> invalidateScheduleByRoom(RoomId roomId, DateTime dayTime);
}
