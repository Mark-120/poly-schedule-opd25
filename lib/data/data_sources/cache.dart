import "package:hive/hive.dart";
import '../../domain/entities/room.dart';
import '../../domain/entities/schedule/week.dart';
import 'base.dart';

class HiveCache<T, K> {
  int entriesCount;
  Box<(T, DateTime)> box;

  HiveCache({required this.box, this.entriesCount = 30});

  T? getValue(K key) {
    return box.get(key)?.$1;
  }

  Future<void> addValue(K key, T value) async {
    await box.put(key, (value, DateTime.now()));
    await _removeExtra();
  }

  Future<void> _removeExtra() async {
    final entries = box.toMap().entries.toList();

    entries.sort((a, b) {
      return a.value.$2.compareTo(b.value.$2);
    });

    // Delete oldest
    final keysToRemove = entries
        .take(box.length - entriesCount)
        .map((e) => e.key);
    await box.deleteAll(keysToRemove);
    return;
  }
}

class CacheDataSource extends PassThroughSource {
  HiveCache<Week, (int, DateTime)> groupScheduleCache;
  HiveCache<Week, (RoomId, DateTime)> roomScheduleCache;
  HiveCache<Week, (int, DateTime)> teacherScheduleCache;
  CacheDataSource({
    required super.prevDataSource,
    required this.groupScheduleCache,
    required this.roomScheduleCache,
    required this.teacherScheduleCache,
  });

  @override
  Future<Week> getScheduleByGroup(int groupId, DateTime dayTime) async {
    var val = groupScheduleCache.getValue((groupId, dayTime));
    if (val == null) {
      var newVal = await prevDataSource.getScheduleByGroup(groupId, dayTime);
      groupScheduleCache.addValue((groupId, dayTime), newVal);
      return newVal;
    }
    return val;
  }

  @override
  Future<Week> getScheduleByRoom(RoomId roomId, DateTime dayTime) async {
    var val = roomScheduleCache.getValue((roomId, dayTime));
    if (val == null) {
      var newVal = await prevDataSource.getScheduleByRoom(roomId, dayTime);
      roomScheduleCache.addValue((roomId, dayTime), newVal);
      return newVal;
    }
    return val;
  }

  @override
  Future<Week> getScheduleByTeacher(int teacherId, DateTime dayTime) async {
    var val = teacherScheduleCache.getValue((teacherId, dayTime));
    if (val == null) {
      var newVal = await prevDataSource.getScheduleByTeacher(
        teacherId,
        dayTime,
      );
      teacherScheduleCache.addValue((teacherId, dayTime), newVal);
      return newVal;
    }
    return val;
  }

  @override
  Future<void> invalidateScheduleByGroup(int groupId, DateTime dayTime) async {
    var newVal = await prevDataSource.getScheduleByGroup(groupId, dayTime);
    if (newVal != groupScheduleCache.getValue((groupId, dayTime))) {
      await groupScheduleCache.addValue((groupId, dayTime), newVal);
    }
  }

  @override
  Future<void> invalidateScheduleByRoom(RoomId roomId, DateTime dayTime) async {
    var newVal = await prevDataSource.getScheduleByRoom(roomId, dayTime);
    if (newVal != roomScheduleCache.getValue((roomId, dayTime))) {
      await roomScheduleCache.addValue((roomId, dayTime), newVal);
    }
  }

  @override
  Future<void> invalidateScheduleByTeacher(
    int teacherId,
    DateTime dayTime,
  ) async {
    var newVal = await prevDataSource.getScheduleByTeacher(teacherId, dayTime);
    if (newVal != teacherScheduleCache.getValue((teacherId, dayTime))) {
      await teacherScheduleCache.addValue((teacherId, dayTime), newVal);
    }
  }
}
