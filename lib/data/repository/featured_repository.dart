import 'package:hive/hive.dart';

import '../../domain/entities/room.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/repositories/featured_repository.dart';

class FeaturedRepositorySourceImpl implements FeaturedRepository {
  Box<Room> featuredRooms;
  Box<Teacher> featuredTeachers;
  Box<Group> featuredGroups;
  FeaturedRepositorySourceImpl({
    required this.featuredRooms,
    required this.featuredTeachers,
    required this.featuredGroups,
  });

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
