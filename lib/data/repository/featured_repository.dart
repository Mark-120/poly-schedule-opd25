import 'package:hive/hive.dart';

import '../../core/exception/local_exception.dart';
import '../../core/logger.dart';
import '../../domain/entities/entity_id.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/room.dart';
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
    logger.debug('[Featured] FeaturedGroup - SET $group');
    await featuredGroups.put(group.id.id, group);
  }

  @override
  Future<void> addFeaturedRoom(Room newRoom) async {
    logger.debug('[Featured] FeaturedRoom - SET $newRoom');
    await featuredRooms.put(newRoom.getId().toString(), newRoom);
  }

  @override
  Future<void> addFeaturedTeacher(Teacher newTeacher) async {
    logger.debug('[Featured] FeaturedTeacher - SET $newTeacher');
    await featuredTeachers.put(newTeacher.id.id, newTeacher);
  }

  @override
  Future<List<Group>> getFeaturedGroups() async {
    logger.debug('[Featured] FeaturedGroups - GET');
    return featuredGroups.values.toList();
  }

  @override
  Future<List<Room>> getFeaturedRooms() async {
    logger.debug('[Featured] FeaturedRooms - GET');
    return featuredRooms.values.toList();
  }

  @override
  Future<List<Teacher>> getFeaturedTeachers() async {
    logger.debug('[Featured] FeaturedTeachers - GET');
    return featuredTeachers.values.toList();
  }

  @override
  Future<void> setFeaturedGroups(List<Group> newGroups) async {
    logger.debug('[Featured] FeaturedGroups - SET $newGroups');
    await featuredGroups.clear();
    await featuredGroups.putAll(
      Map.fromIterables(newGroups.map((x) => x.id.id), newGroups),
    );
  }

  @override
  Future<void> setFeaturedRooms(List<Room> newRooms) async {
    logger.debug('[Featured] FeaturedRooms - SET $newRooms');
    await featuredRooms.clear();
    await featuredRooms.putAll(
      Map.fromIterables(newRooms.map((x) => x.getId().toString()), newRooms),
    );
  }

  @override
  Future<void> setFeaturedTeachers(List<Teacher> newTeachers) async {
    logger.debug('[Featured] FeaturedTeachers - SET $newTeachers');
    await featuredTeachers.clear();
    await featuredTeachers.putAll(
      Map.fromIterables(newTeachers.map((x) => x.id.id), newTeachers),
    );
  }

  @override
  Future<bool> isSavedInFeatured(EntityId id) async {
    if (id.isTeacher) {
      return (await getFeaturedGroups()).any((x) => x.id == id.asTeacher);
    } else if (id.isRoom) {
      return (await getFeaturedRooms()).any((x) => x.getId() == id.asRoom);
    } else if (id.isGroup) {
      return (await getFeaturedGroups()).any((x) => x.id == id.asGroup);
    }
    return throw LocalException('non valid id');
  }

  @override
  Future<void> deleteFeatured(EntityId id) async {
    if (id.isTeacher) {
      return featuredTeachers.delete(id.asTeacher.id);
    } else if (id.isRoom) {
      return featuredRooms.delete(id.asRoom.toString());
    } else if (id.isGroup) {
      return featuredGroups.delete(id.asGroup.id);
    }
  }
}
