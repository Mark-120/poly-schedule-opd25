import '../../domain/repositories/schedule_repository.dart';

import '../../domain/entities/group.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/building.dart';
import '../../domain/entities/schedule/week.dart';
import '../data_sources/remote.dart';

class ScheduleRepositoryImpl extends ScheduleRepository {
  final RemoteDataSourceImpl remoteSource;
  ScheduleRepositoryImpl(this.remoteSource);
  @override
  Future<List<Teacher>> findTeachers(String query) =>
      remoteSource.findTeachers(query);

  @override
  Future<List<Group>> findGroups(String query) =>
      remoteSource.findGroups(query);
  @override
  Future<List<Building>> getAllBuildings() => remoteSource.getAllBuildings();

  @override
  Future<List<Room>> getAllRoomsOfBuilding(int buildingId) async =>
      remoteSource.getAllRoomsOfBuilding(buildingId);
  @override
  Future<Week> getScheduleByTeacher(int teacherId, DateTime dayTime) =>
      remoteSource.getScheduleByTeacher(teacherId, dayTime);
  @override
  Future<Week> getScheduleByGroup(int groupId, DateTime dayTime) =>
      remoteSource.getScheduleByGroup(groupId, dayTime);
  @override
  Future<Week> getScheduleByRoom(RoomId roomId, DateTime dayTime) =>
      remoteSource.getScheduleByRoom(roomId, dayTime);
}
