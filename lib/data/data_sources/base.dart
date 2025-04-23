import '../../domain/entities/room.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/building.dart';
import '../../domain/entities/schedule/week.dart';

abstract class DataSource {
  Future<List<Teacher>> findTeachers(String query);
  Future<List<Group>> findGroups(String query);

  Future<List<Building>> getAllBuildings();

  Future<List<Room>> getAllRoomsOfBuilding(int buildingId);

  Future<Teacher> getTeacher(int teacherId);
  Future<Group> getGroup(int groupId);
  Future<Room> getRoom(RoomId roomId);

  Future<Week> getScheduleByTeacher(int teacherId, DateTime dayTime);
  Future<Week> getScheduleByGroup(int groupId, DateTime dayTime);
  Future<Week> getScheduleByRoom(RoomId roomId, DateTime dayTime);
}

class PassThroughSource extends DataSource {
  final DataSource prevDataSource;
  PassThroughSource({required this.prevDataSource});

  @override
  Future<List<Group>> findGroups(String query) =>
      prevDataSource.findGroups(query);

  @override
  Future<List<Teacher>> findTeachers(String query) =>
      prevDataSource.findTeachers(query);

  @override
  Future<List<Building>> getAllBuildings() =>
      prevDataSource.getAllBuildings();

  @override
  Future<List<Room>> getAllRoomsOfBuilding(int building) =>
      prevDataSource.getAllRoomsOfBuilding(building);

  @override
  Future<Group> getGroup(int groupId) => prevDataSource.getGroup(groupId);

  @override
  Future<Room> getRoom(RoomId roomId) => prevDataSource.getRoom(roomId);

  @override
  Future<Teacher> getTeacher(int teacherId) =>
      prevDataSource.getTeacher(teacherId);

  @override
  Future<Week> getScheduleByGroup(int groupId, DateTime dayTime) =>
      prevDataSource.getScheduleByGroup(groupId, dayTime);

  @override
  Future<Week> getScheduleByRoom(RoomId roomId, DateTime dayTime) =>
      prevDataSource.getScheduleByRoom(roomId, dayTime);

  @override
  Future<Week> getScheduleByTeacher(int teacherId, DateTime dayTime) =>
      prevDataSource.getScheduleByTeacher(teacherId, dayTime);
}
