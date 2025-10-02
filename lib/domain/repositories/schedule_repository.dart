import '../entities/building.dart';
import '../entities/entity_id.dart';
import '../entities/group.dart';
import '../entities/room.dart';
import '../entities/schedule/week.dart';
import '../entities/teacher.dart';

abstract class ScheduleRepository {
  const ScheduleRepository();
  Future<List<Teacher>> findTeachers(String query);
  Future<List<Group>> findGroups(String query);

  Future<List<Building>> getAllBuildings();
  Future<List<Room>> getAllRoomsOfBuilding(int buildingId);

  Future<Week> getSchedule(EntityId entityId, DateTime dayTime);

  Future<void> invalidateSchedule(EntityId entityId, DateTime dayTime);
}
