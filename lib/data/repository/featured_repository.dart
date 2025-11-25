import 'package:hive/hive.dart';

import '../../core/exception/local_exception.dart';
import '../../core/logger.dart';
import '../../domain/entities/entity.dart';
import '../../domain/entities/entity_id.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/repositories/featured_repository.dart';

class OrderedEntity<T extends ScheduleEntity> {
  T value;
  int order;
  OrderedEntity(this.value, this.order);
}

class FeaturedRepositorySourceImpl implements FeaturedRepository {
  final AppLogger logger;

  Box<int> indexBox;

  static int roomKey = 0;
  static int teacherKey = 0;
  static int groupKey = 0;

  Box<OrderedEntity<Room>> featuredRooms;
  Box<OrderedEntity<Teacher>> featuredTeachers;
  Box<OrderedEntity<Group>> featuredGroups;

  FeaturedRepositorySourceImpl({
    required this.indexBox,
    required this.featuredRooms,
    required this.featuredTeachers,
    required this.featuredGroups,
    required this.logger,
  });
  Future<int> incrimentId(int key) async {
    final old = indexBox.get(key) ?? 0;
    final next = old + 1;
    await indexBox.put(key, next);
    return next;
  }

  Future<void> setId(int key, int value) {
    return indexBox.put(key, value);
  }

  @override
  Future<void> addFeaturedGroup(Group group) async {
    logger.debug('[Featured] FeaturedGroup - SET $group');

    var id = await incrimentId(groupKey);

    await featuredGroups.put(group.id.id, OrderedEntity(group, id));
  }

  @override
  Future<void> addFeaturedRoom(Room newRoom) async {
    logger.debug('[Featured] FeaturedRoom - SET $newRoom');

    var id = await incrimentId(roomKey);

    await featuredRooms.put(
      newRoom.getId().toString(),
      OrderedEntity(newRoom, id),
    );
  }

  @override
  Future<void> addFeaturedTeacher(Teacher newTeacher) async {
    logger.debug('[Featured] FeaturedTeacher - SET $newTeacher');

    var id = await incrimentId(teacherKey);

    await featuredTeachers.put(newTeacher.id.id, OrderedEntity(newTeacher, id));
  }

  @override
  Future<List<Group>> getFeaturedGroups() async {
    logger.debug('[Featured] FeaturedGroups - GET');

    var list = featuredGroups.values.toList();
    list.sort((a, b) => a.order.compareTo(b.order));

    return list.map((x) => x.value).toList();
  }

  @override
  Future<List<Room>> getFeaturedRooms() async {
    logger.debug('[Featured] FeaturedRooms - GET');

    var list = featuredRooms.values.toList();
    list.sort((a, b) => a.order.compareTo(b.order));

    return list.map((x) => x.value).toList();
  }

  @override
  Future<List<Teacher>> getFeaturedTeachers() async {
    logger.debug('[Featured] FeaturedTeachers - GET');

    var list = featuredTeachers.values.toList();
    list.sort((a, b) => a.order.compareTo(b.order));

    return list.map((x) => x.value).toList();
  }

  @override
  Future<void> setFeaturedGroups(List<Group> newGroups) async {
    logger.debug('[Featured] FeaturedGroups - SET $newGroups');
    await featuredGroups.clear();

    setId(groupKey, newGroups.length);

    await featuredGroups.putAll(
      Map.fromIterables(
        newGroups.map((x) => x.id.id),
        newGroups.indexed.map((x) => OrderedEntity(x.$2, x.$1)),
      ),
    );
  }

  @override
  Future<void> setFeaturedRooms(List<Room> newRooms) async {
    logger.debug('[Featured] FeaturedRooms - SET $newRooms');
    await featuredRooms.clear();

    setId(roomKey, newRooms.length);

    await featuredRooms.putAll(
      Map.fromIterables(
        newRooms.map((x) => x.getId().toString()),
        newRooms.indexed.map((x) => OrderedEntity(x.$2, x.$1)),
      ),
    );
  }

  @override
  Future<void> setFeaturedTeachers(List<Teacher> newTeachers) async {
    logger.debug('[Featured] FeaturedTeachers - SET $newTeachers');
    await featuredTeachers.clear();

    setId(teacherKey, newTeachers.length);

    await featuredTeachers.putAll(
      Map.fromIterables(
        newTeachers.map((x) => x.id.id),
        newTeachers.indexed.map((x) => OrderedEntity(x.$2, x.$1)),
      ),
    );
  }

  @override
  Future<bool> isSavedInFeatured(EntityId id) async {
    logger.debug('[Featured] FeaturedRooms - isSavedInFeatured');

    if (id.isTeacher) {
      return featuredTeachers.containsKey(id.asTeacher.id);
    } else if (id.isRoom) {
      return featuredRooms.containsKey(id.asRoom.toString());
    } else if (id.isGroup) {
      return featuredGroups.containsKey(id.asGroup.id);
    }
    return throw LocalException('non valid id');
  }

  @override
  Future<void> deleteFeatured(EntityId id) async {
    logger.debug('[Featured] FeaturedRooms - deleteFeatured');
    if (id.isTeacher) {
      return featuredTeachers.delete(id.asTeacher.id);
    } else if (id.isRoom) {
      return featuredRooms.delete(id.asRoom.toString());
    } else if (id.isGroup) {
      return featuredGroups.delete(id.asGroup.id);
    }
  }
}
