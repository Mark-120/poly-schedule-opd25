import 'package:poly_scheduler/domain/entities/schedule/week.dart';

import '../entities/group.dart';
import '../entities/teacher.dart';
import '../entities/room.dart';
import '../entities/building.dart';

abstract class ScheduleRepository {
  Future<List<Teacher>> findTeachers(String query);
  Future<List<Group>> findGroups(String query);

  Future<List<Building>> getAllBuildings();
  Future<List<Room>> getAllRoomsOfBuilding(int buildingId);

  Future<Week> getScheduleByTeacher(int teacherId, DateTime time);
  Future<Week> getScheduleByGroup(int groupId, DateTime time);
  Future<Week> getScheduleByRoom(RoomId roomId, DateTime time);
}
