import 'package:hive/hive.dart';

import '../../domain/entities/room.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/teacher.dart';
import 'base.dart';

abstract class FeaturedDataSource {
  Future<List<Teacher>> getFeaturedTeachers();
  Future<void> setFeaturedTeachers(List<int> newTeacherIds);
  Future<void> addFeaturedTeacher(int newTeacherId);

  Future<List<Group>> getFeaturedGroups();
  Future<void> setFeaturedGroups(List<int> newGroupIds);
  Future<void> addFeaturedGroup(int newGroupId);

  Future<List<Room>> getFeaturedRooms();
  Future<void> setFeaturedRooms(List<RoomId> newRoomIds);
  Future<void> addFeaturedRoom(RoomId newRoomId);
}

class FeaturedDataSourceImpl extends PassThroughSource
    implements FeaturedDataSource {
  Box<Room> featuredRooms;
  Box<Teacher> featuredTeachers;
  Box<Group> featuredGroups;
  FeaturedDataSourceImpl({
    required super.prevDataSource,
    required this.featuredRooms,
    required this.featuredTeachers,
    required this.featuredGroups,
  });

  @override
  Future<Group> getGroup(int groupId) async {
    return featuredGroups.get(groupId) ??
        (await prevDataSource.getGroup(groupId));
  }

  @override
  Future<Room> getRoom(RoomId roomId) async {
    return featuredRooms.get(roomId) ?? (await prevDataSource.getRoom(roomId));
  }

  @override
  Future<Teacher> getTeacher(int teacherId) async {
    return featuredTeachers.get(teacherId) ??
        (await prevDataSource.getTeacher(teacherId));
  }

  @override
  Future<void> addFeaturedGroup(int groupId) async {
    await featuredGroups.put(groupId, await prevDataSource.getGroup(groupId));
  }

  @override
  Future<void> addFeaturedRoom(RoomId newRoomId) async {
    await featuredRooms.put(newRoomId, await prevDataSource.getRoom(newRoomId));
  }

  @override
  Future<void> addFeaturedTeacher(int newTeacherId) async {
    await featuredTeachers.put(
      newTeacherId,
      await prevDataSource.getTeacher(newTeacherId),
    );
  }

  @override
  Future<List<Group>> getFeaturedGroups() async {
    return featuredGroups.values.toList();
  }

  @override
  Future<List<Room>> getFeaturedRooms() async {
    return featuredRooms.values.toList();
  }

  @override
  Future<List<Teacher>> getFeaturedTeachers() async {
    return featuredTeachers.values.toList();
  }

  @override
  Future<void> setFeaturedGroups(List<int> newGroupIds) async {
    var newGroups = await Future.wait(
      newGroupIds.map((i) async => await getGroup(i)),
    );

    featuredGroups.clear();
    featuredGroups.putAll(Map.fromIterables(newGroupIds, newGroups));
  }

  @override
  Future<void> setFeaturedRooms(List<RoomId> newRoomIds) async {
    var newRooms = await Future.wait(
      newRoomIds.map((i) async => await getRoom(i)),
    );

    featuredRooms.clear();
    featuredRooms.putAll(Map.fromIterables(newRoomIds, newRooms));
  }

  @override
  Future<void> setFeaturedTeachers(List<int> newTeacherIds) async {
    var newTeachers = await Future.wait(
      newTeacherIds.map((i) async => await getTeacher(i)),
    );

    featuredTeachers.clear();
    featuredTeachers.putAll(Map.fromIterables(newTeacherIds, newTeachers));
  }
}
