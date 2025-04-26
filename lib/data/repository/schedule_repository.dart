import '../data_sources/base.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/building.dart';
import '../../domain/entities/schedule/week.dart';
import '../../core/date_formater.dart';

class ScheduleRepositoryImpl extends ScheduleRepository {
  final DataSource dataSource;
  ScheduleRepositoryImpl(this.dataSource);
  @override
  Future<List<Teacher>> findTeachers(String query) =>
      dataSource.findTeachers(query);

  @override
  Future<List<Group>> findGroups(String query) => dataSource.findGroups(query);
  @override
  Future<List<Building>> getAllBuildings() => dataSource.getAllBuildings();
  @override
  Future<List<Room>> getAllRoomsOfBuilding(int buildingId) async =>
      dataSource.getAllRoomsOfBuilding(buildingId);

  @override
  Future<Week> getScheduleByTeacher(int teacherId, DateTime dayTime) =>
      dataSource.getScheduleByTeacher(
        teacherId,
        DateFormater.truncDate(dayTime),
      );
  @override
  Future<Week> getScheduleByGroup(int groupId, DateTime dayTime) =>
      dataSource.getScheduleByGroup(groupId, DateFormater.truncDate(dayTime));
  @override
  Future<Week> getScheduleByRoom(RoomId roomId, DateTime dayTime) =>
      dataSource.getScheduleByRoom(roomId, DateFormater.truncDate(dayTime));
}
