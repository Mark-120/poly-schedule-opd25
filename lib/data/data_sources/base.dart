import '../../domain/entities/room.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/building.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../domain/entities/schedule/week.dart';

class PassThroughSource extends ScheduleRepository {
  final ScheduleRepository prevDataSource;
  PassThroughSource({required this.prevDataSource});

  @override
  Future<List<Group>> findGroups(String query) =>
      prevDataSource.findGroups(query);

  @override
  Future<List<Teacher>> findTeachers(String query) =>
      prevDataSource.findTeachers(query);

  @override
  Future<List<Building>> getAllBuildings() => prevDataSource.getAllBuildings();

  @override
  Future<List<Room>> getAllRoomsOfBuilding(int building) =>
      prevDataSource.getAllRoomsOfBuilding(building);

  @override
  Future<Week> getScheduleByGroup(int groupId, DateTime dayTime) =>
      prevDataSource.getScheduleByGroup(groupId, dayTime);

  @override
  Future<Week> getScheduleByRoom(RoomId roomId, DateTime dayTime) =>
      prevDataSource.getScheduleByRoom(roomId, dayTime);

  @override
  Future<Week> getScheduleByTeacher(int teacherId, DateTime dayTime) =>
      prevDataSource.getScheduleByTeacher(teacherId, dayTime);

  @override
  Future<void> invalidateScheduleByGroup(int groupId, DateTime dayTime) =>
      prevDataSource.invalidateScheduleByGroup(groupId, dayTime);

  @override
  Future<void> invalidateScheduleByRoom(RoomId roomId, DateTime dayTime) =>
      prevDataSource.invalidateScheduleByRoom(roomId, dayTime);

  @override
  Future<void> invalidateScheduleByTeacher(int teacherId, DateTime dayTime) =>
      prevDataSource.invalidateScheduleByTeacher(teacherId, dayTime);
}
