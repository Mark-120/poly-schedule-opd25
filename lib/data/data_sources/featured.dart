import 'package:hive/hive.dart';

import '../../domain/entities/room.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/teacher.dart';
import 'base.dart';

abstract class FeaturedDataSource {
  Future<List<Teacher>> getFeaturedTeachers();
  Future<void> setFeaturedTeachers(List<Teacher> newTeachers);
  Future<void> addFeaturedTeacher(Teacher newTeacher);

  Future<List<Group>> getFeaturedGroups();
  Future<void> setFeaturedGroups(List<Group> newGroups);
  Future<void> addFeaturedGroup(Group newGroup);

  Future<List<Room>> getFeaturedRooms();
  Future<void> setFeaturedRooms(List<Room> newRooms);
  Future<void> addFeaturedRoom(Room newRoom);
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
  Future<void> addFeaturedGroup(Group group) async {
    await featuredGroups.put(group.id, group);
  }

  @override
  Future<void> addFeaturedRoom(Room newRoom) async {
    await featuredRooms.put(newRoom.getId(), newRoom);
  }

  @override
  Future<void> addFeaturedTeacher(Teacher newTeacher) async {
    await featuredTeachers.put(newTeacher.id, newTeacher);
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
  Future<void> setFeaturedGroups(List<Group> newGroups) async {
    featuredGroups.clear();
    featuredGroups.putAll(
      Map.fromIterables(newGroups.map((x) => x.id), newGroups),
    );
  }

  @override
  Future<void> setFeaturedRooms(List<Room> newRooms) async {
    featuredRooms.clear();
    featuredRooms.putAll(
      Map.fromIterables(newRooms.map((x) => x.getId()), newRooms),
    );
  }

  @override
  Future<void> setFeaturedTeachers(List<Teacher> newTeachers) async {
    featuredTeachers.clear();
    featuredTeachers.putAll(
      Map.fromIterables(newTeachers.map((x) => x.id), newTeachers),
    );
  }
}
