import '../models/teacher.dart';
import '../models/group.dart';
import '../models/room.dart';
import '../models/building.dart';
import '../models/schedule/week.dart';
import '../../domain/entities/room.dart';

abstract class DataSource {
  Future<List<TeacherModel>> findTeachers(String query);
  Future<List<GroupModel>> findGroups(String query);

  Future<List<BuildingModel>> getAllBuildings();

  Future<List<RoomModel>> getAllRoomsOfBuilding(int buildingId);

  Future<TeacherModel> getTeacher(int teacherId);
  Future<GroupModel> getGroup(int groupId);
  Future<RoomModel> getRoom(RoomId roomId);

  Future<WeekModel> getScheduleByTeacher(int teacherId, DateTime dayTime);
  Future<WeekModel> getScheduleByGroup(int groupId, DateTime dayTime);
  Future<WeekModel> getScheduleByRoom(RoomId roomId, DateTime dayTime);
}

class PassThroughSource extends DataSource {
  final DataSource prevDataSource;
  PassThroughSource({required this.prevDataSource});

  @override
  Future<List<GroupModel>> findGroups(String query) =>
      prevDataSource.findGroups(query);

  @override
  Future<List<TeacherModel>> findTeachers(String query) =>
      prevDataSource.findTeachers(query);

  @override
  Future<List<BuildingModel>> getAllBuildings() =>
      prevDataSource.getAllBuildings();

  @override
  Future<List<RoomModel>> getAllRoomsOfBuilding(int building) =>
      prevDataSource.getAllRoomsOfBuilding(building);

  @override
  Future<GroupModel> getGroup(int groupId) => prevDataSource.getGroup(groupId);

  @override
  Future<RoomModel> getRoom(RoomId roomId) => prevDataSource.getRoom(roomId);

  @override
  Future<TeacherModel> getTeacher(int teacherId) =>
      prevDataSource.getTeacher(teacherId);

  @override
  Future<WeekModel> getScheduleByGroup(int groupId, DateTime dayTime) =>
      prevDataSource.getScheduleByGroup(groupId, dayTime);

  @override
  Future<WeekModel> getScheduleByRoom(RoomId roomId, DateTime dayTime) =>
      prevDataSource.getScheduleByRoom(roomId, dayTime);

  @override
  Future<WeekModel> getScheduleByTeacher(int teacherId, DateTime dayTime) =>
      prevDataSource.getScheduleByTeacher(teacherId, dayTime);
}
