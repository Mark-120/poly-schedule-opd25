import '../../domain/entities/building.dart';
import '../../domain/entities/entity_id.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/schedule/week.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../data_sources/base.dart';

class ScheduleRepositoryImpl extends ScheduleRepository {
  final FetchDataSource fetchDataSource;
  final ScheduleDataSource scheduleDataSource;
  const ScheduleRepositoryImpl({
    required this.fetchDataSource,
    required this.scheduleDataSource,
  });

  @override
  Future<List<Group>> findGroups(String query) {
    return fetchDataSource.findGroups(query);
  }

  @override
  Future<List<Teacher>> findTeachers(String query) {
    return fetchDataSource.findTeachers(query);
  }

  @override
  Future<List<Building>> getAllBuildings() {
    return fetchDataSource.getAllBuildings();
  }

  @override
  Future<List<Room>> getAllRoomsOfBuilding(int buildingId) {
    return fetchDataSource.getAllRoomsOfBuilding(buildingId);
  }

  @override
  Future<Week> getSchedule(EntityId entityId, DateTime dayTime) {
    return scheduleDataSource.getSchedule(entityId, dayTime);
  }

  @override
  Future<void> invalidateSchedule(EntityId entityId, DateTime dayTime) {
    return scheduleDataSource.invalidateSchedule(entityId, dayTime);
  }
}
