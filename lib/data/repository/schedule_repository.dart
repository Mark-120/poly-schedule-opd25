import 'package:poly_scheduler/domain/entities/building.dart';

import 'package:poly_scheduler/domain/entities/group.dart';

import 'package:poly_scheduler/domain/entities/room.dart';

import 'package:poly_scheduler/domain/entities/schedule/week.dart';

import 'package:poly_scheduler/domain/entities/teacher.dart';

import '../../domain/entities/entity_id.dart';
import '../data_sources/base.dart';
import '../../domain/repositories/schedule_repository.dart';

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
  Future<Week> getScheduleByGroup(GroupId groupId, DateTime dayTime) {
    return scheduleDataSource.getSchedule(EntityId.group(groupId), dayTime);
  }

  @override
  Future<Week> getScheduleByRoom(RoomId roomId, DateTime dayTime) {
    return scheduleDataSource.getSchedule(EntityId.room(roomId), dayTime);
  }

  @override
  Future<Week> getScheduleByTeacher(TeacherId teacherId, DateTime dayTime) {
    return scheduleDataSource.getSchedule(EntityId.teacher(teacherId), dayTime);
  }

  @override
  Future<void> invalidateScheduleByGroup(GroupId groupId, DateTime dayTime) {
    return scheduleDataSource.invalidateSchedule(
      EntityId.group(groupId),
      dayTime,
    );
  }

  @override
  Future<void> invalidateScheduleByRoom(RoomId roomId, DateTime dayTime) {
    return scheduleDataSource.invalidateSchedule(
      EntityId.room(roomId),
      dayTime,
    );
  }

  @override
  Future<void> invalidateScheduleByTeacher(
    TeacherId teacherId,
    DateTime dayTime,
  ) {
    return scheduleDataSource.invalidateSchedule(
      EntityId.teacher(teacherId),
      dayTime,
    );
  }
}
