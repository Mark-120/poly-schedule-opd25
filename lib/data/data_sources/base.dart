import '../../domain/entities/building.dart';
import '../../domain/entities/entity_id.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/schedule/week.dart';
import '../../domain/entities/teacher.dart';

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
