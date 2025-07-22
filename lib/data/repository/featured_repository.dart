import 'package:hive/hive.dart';

import '../../core/logger.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/repositories/featured_repository.dart';

class FeaturedRepositorySourceImpl implements FeaturedRepository {
  final AppLogger logger;
  Box<Room> featuredRooms;
  Box<Teacher> featuredTeachers;
  Box<Group> featuredGroups;
  FeaturedRepositorySourceImpl({
    required this.featuredRooms,
    required this.featuredTeachers,
    required this.featuredGroups,
    required this.logger,
  });

  @override
  Future<void> addFeaturedGroup(Group group) async {
    logger.debug('[Cache] FeaturedGroup - SET $group');
    await featuredGroups.put(group.id, group);
  }

  @override
  Future<void> addFeaturedRoom(Room newRoom) async {
    logger.debug('[Cache] FeaturedRoom - SET $newRoom');
    await featuredRooms.put(newRoom.getId().toString(), newRoom);
  }

  @override
  Future<void> addFeaturedTeacher(Teacher newTeacher) async {
    logger.debug('[Cache] FeaturedTeacher - SET $newTeacher');
    await featuredTeachers.put(newTeacher.id, newTeacher);
  }

  @override
  Future<List<Group>> getFeaturedGroups() async {
    logger.debug('[Cache] FeaturedGroups - GET');
    return featuredGroups.values.toList();
  }

  @override
  Future<List<Room>> getFeaturedRooms() async {
    logger.debug('[Cache] FeaturedRooms - GET');
    return featuredRooms.values.toList();
  }

  @override
  Future<List<Teacher>> getFeaturedTeachers() async {
    logger.debug('[Cache] FeaturedTeachers - GET');
    return featuredTeachers.values.toList();
  }

  @override
  Future<void> setFeaturedGroups(List<Group> newGroups) async {
    logger.debug('[Cache] FeaturedGroups - SET $newGroups');
    featuredGroups.clear();
    featuredGroups.putAll(
      Map.fromIterables(newGroups.map((x) => x.id), newGroups),
    );
  }

  @override
  Future<void> setFeaturedRooms(List<Room> newRooms) async {
    logger.debug('[Cache] FeaturedRooms - SET $newRooms');
    featuredRooms.clear();
    featuredRooms.putAll(
      Map.fromIterables(newRooms.map((x) => x.getId().toString()), newRooms),
    );
  }

  @override
  Future<void> setFeaturedTeachers(List<Teacher> newTeachers) async {
    logger.debug('[Cache] FeaturedTeachers - SET $newTeachers');
    featuredTeachers.clear();
    featuredTeachers.putAll(
      Map.fromIterables(newTeachers.map((x) => x.id), newTeachers),
    );
  }
}
