import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

import 'package:poly_scheduler/core/logger.dart';
import 'package:poly_scheduler/data/adapters/building.dart';
import 'package:poly_scheduler/data/adapters/date.dart';
import 'package:poly_scheduler/data/adapters/entity_id.dart';
import 'package:poly_scheduler/data/adapters/featured.dart';
import 'package:poly_scheduler/data/adapters/group.dart';
import 'package:poly_scheduler/data/adapters/ordered/ordered.dart';
import 'package:poly_scheduler/data/adapters/room.dart';
import 'package:poly_scheduler/data/adapters/teacher.dart';
import 'package:poly_scheduler/data/models/building.dart';
import 'package:poly_scheduler/data/models/group.dart';
import 'package:poly_scheduler/data/models/room.dart';
import 'package:poly_scheduler/data/models/teacher.dart';
import 'package:poly_scheduler/data/repository/featured_repository.dart';
import 'package:poly_scheduler/domain/entities/building.dart';
import 'package:poly_scheduler/domain/entities/group.dart';
import 'package:poly_scheduler/domain/entities/room.dart';
import 'package:poly_scheduler/domain/entities/teacher.dart';
import 'package:poly_scheduler/domain/repositories/featured_repository.dart';

void main() {
  late FeaturedRepository repo;
  late Box<OrderedEntity<Group>> groupBox;
  late Box<OrderedEntity<Room>> roomBox;
  late Box<OrderedEntity<Teacher>> teacherBox;
  late Box<int> indexBox;
  setUpAll(() async {
    Hive.registerAdapter(RoomIdAdapter());
    Hive.registerAdapter(TeacherIdAdapter());
    Hive.registerAdapter(GroupIdAdapter());

    Hive.registerAdapter(DateAdapter());
    Hive.registerAdapter(TeacherAdapter());
    Hive.registerAdapter(RoomAdapter());
    Hive.registerAdapter(RoomIdAdapter());
    Hive.registerAdapter(BuildingAdapter());
    Hive.registerAdapter(GroupAdapter());
    Hive.registerAdapter(FeaturedAdapter());
    Hive.registerAdapter(OrderedEntityAdapter());
  });

  setUp(() async {
    await setUpTestHive(); // creates an isolated temp directory

    groupBox = await Hive.openBox<OrderedEntity<Group>>('groups');
    roomBox = await Hive.openBox<OrderedEntity<Room>>('rooms');
    teacherBox = await Hive.openBox<OrderedEntity<Teacher>>('teachers');
    indexBox = await Hive.openBox<int>('id');

    repo = FeaturedRepositorySourceImpl(
      indexBox: indexBox,
      featuredGroups: groupBox,
      featuredRooms: roomBox,
      featuredTeachers: teacherBox,
      logger: DevLogger(),
    );
  });

  tearDown(() async {
    await tearDownTestHive();
  });

  Group buildGroup(int id) => GroupModel(id: GroupId(id), name: 'G$id');

  Building buildBuilding(int id) =>
      BuildingModel(id: id, name: 'B$id', abbr: 'Ab$id', address: 'Ad$id');

  Room buildRoomDefault(int id) =>
      RoomModel(id: id, name: 'R$id', building: buildBuilding(0));

  Room buildRoom(int id, Building building) =>
      RoomModel(id: id, name: 'R$id', building: building);

  Teacher buildTeacher(int id) =>
      TeacherModel(id: TeacherId(id), fullName: 'T$id');

  group('add to Featured Repository', () {
    test('addFeaturedGroup adds a group to Hive', () async {
      final g = buildGroup(1);

      await repo.addFeaturedGroup(g);

      expect(groupBox.get(1)!.value.id.id, 1);
    });

    test('addFeaturedRoom adds a room to Hive', () async {
      final r = buildRoom(2, buildBuilding(12));

      await repo.addFeaturedRoom(r);

      expect(roomBox.get(r.getId().toString())!.value.getId().roomId, 2);
      expect(roomBox.get(r.getId().toString())!.value.getId().buildingId, 12);
    });

    test('addFeaturedTeacher adds a teacher to Hive', () async {
      final t = buildTeacher(3);

      await repo.addFeaturedTeacher(t);

      expect(teacherBox.get(3)!.value.id.id, 3);
    });
  });
  group('get from Featured Repository', () {
    test('getFeaturedGroups returns all groups', () async {
      await groupBox.putAll({
        '1': OrderedEntity(buildGroup(1), 0),
        '2': OrderedEntity(buildGroup(2), 0),
      });

      final result = await repo.getFeaturedGroups();
      expect(result.length, 2);
      expect(result[1].id.id, 2);
    });

    test('getFeaturedRooms returns all rooms', () async {
      final building = buildBuilding(10);
      final rooms = [
        OrderedEntity(buildRoom(1, building), 0),
        OrderedEntity(buildRoom(2, building), 0),
      ];

      await roomBox.putAll(
        Map.fromIterables(rooms.map((x) => x.value.getId().toString()), rooms),
      );

      final result = await repo.getFeaturedRooms();
      expect(result.length, 2);
      expect(result[1].id, 2);
      expect(result[1].building.id, 10);
    });

    test('getFeaturedTeachers returns all teachers', () async {
      await teacherBox.putAll({
        '1': OrderedEntity(buildTeacher(1), 0),
        '2': OrderedEntity(buildTeacher(2), 1),
      });

      final result = await repo.getFeaturedTeachers();
      expect(result.length, 2);
      expect(result[1].id.id, 2);
    });
  });

  group('isSavedInFeatured', () {
    test('isSavedInFeatured returns true for saved group', () async {
      final g = buildGroup(1);
      await repo.addFeaturedGroup(g);

      final id = (GroupId(1));

      final result = await repo.isSavedInFeatured(id);

      expect(result, true);
    });

    test('isSavedInFeatured returns false for missing room', () async {
      final id = (TeacherId(1));
      final result = await repo.isSavedInFeatured(id);

      expect(result, false);
    });
  });
  group('set Featured', () {
    test('setFeaturedGroups replaces all groups', () async {
      await groupBox.put(0, OrderedEntity(buildGroup(0), 0));

      await repo.setFeaturedGroups([buildGroup(1), buildGroup(2)]);

      expect(groupBox.length, 2);
      expect(groupBox.get(2)!.value.id.id, 2);
    });

    test('setFeaturedRooms replaces all rooms', () async {
      await roomBox.put(0, OrderedEntity(buildRoomDefault(0), 1));
      var roomId = RoomId(roomId: 1, buildingId: 0);
      await repo.setFeaturedRooms([buildRoomDefault(1), buildRoomDefault(2)]);

      expect(roomBox.length, 2);
      expect(roomBox.get(roomId.toString())!.value.getId(), roomId);
    });

    test('setFeaturedTeachers replaces all teachers', () async {
      await teacherBox.put(0, OrderedEntity(buildTeacher(0), 0));

      await repo.setFeaturedTeachers([buildTeacher(1), buildTeacher(2)]);

      expect(teacherBox.length, 2);
      expect(teacherBox.get(1)!.value.id.id, 1);
    });
  });
  group('delete from Featured', () {
    test('deleteFeatured removes group by EntityId', () async {
      final g1 = buildGroup(1);
      final g2 = buildGroup(2);

      await repo.setFeaturedGroups([g1, g2]);

      await repo.deleteFeatured((GroupId(1)));

      final result = await repo.getFeaturedGroups();
      expect(result.length, 1);
      expect(result.first.id.id, 2);
    });

    test('deleteFeatured removes teacher by EntityId', () async {
      final t1 = buildTeacher(1);
      final t2 = buildTeacher(2);

      await repo.setFeaturedTeachers([t1, t2]);

      await repo.deleteFeatured((TeacherId(1)));

      final result = await repo.getFeaturedTeachers();
      expect(result.length, 1);
      expect(result.first.id.id, 2);
    });

    test('deleteFeatured removes room by EntityId', () async {
      final r1 = buildRoomDefault(1);
      final r2 = buildRoomDefault(2);

      await repo.setFeaturedRooms([r1, r2]);

      await repo.deleteFeatured((RoomId(roomId: 1, buildingId: 0)));

      final result = await repo.getFeaturedRooms();
      expect(result.length, 1);
      expect(result.first.id, 2);
    });
  });

  group('order of Entities', () {
    test('set List Order - 1', () async {
      final t1 = buildTeacher(2);
      final t2 = buildTeacher(1);

      await repo.setFeaturedTeachers([t1, t2]);

      final result = await repo.getFeaturedTeachers();
      expect(result.first.id.id, 2);
    });
    test('set List Order - 2', () async {
      final t1 = buildTeacher(1);
      final t2 = buildTeacher(2);

      await repo.setFeaturedTeachers([t1, t2]);

      final result = await repo.getFeaturedTeachers();
      expect(result.first.id.id, 1);
    });
    test('add Featured Order - 1', () async {
      final t1 = buildTeacher(3);
      final t2 = buildTeacher(2);
      final t3 = buildTeacher(1);

      await repo.setFeaturedTeachers([t1, t2]);

      await repo.addFeaturedTeacher(t3);

      final result = await repo.getFeaturedTeachers();
      expect(result.last.id.id, 1);
    });
    test('remove Featured Order - 1', () async {
      final t1 = buildTeacher(3);
      final t2 = buildTeacher(2);
      final t3 = buildTeacher(1);

      await repo.setFeaturedTeachers([t1, t2, t3]);

      await repo.deleteFeatured((t2.id));

      final result = await repo.getFeaturedTeachers();
      expect(result.first.id.id, 3);
      expect(result.last.id.id, 1);
    });
  });
}
