import 'dart:math';
import "package:hive/hive.dart";
import '../../domain/entities/room.dart';
import '../../domain/entities/schedule/week.dart';
import 'base.dart';

class HiveCache<T, K> {
  int entriesCount;
  Box<(T, DateTime)> box;

  HiveCache({required this.box, this.entriesCount = 30});

  T? getValue(K key) {
    return box.get(key.toString())?.$1;
  }

  Future<void> addValue(K key, T value) async {
    await box.put(key.toString(), (value, DateTime.now()));
    await _removeExtra();
  }

  Future<void> _removeExtra() async {
    final entries = box.toMap().entries.toList();

    entries.sort((a, b) {
      return a.value.$2.compareTo(b.value.$2);
    });

    // Delete oldest
    final keysToRemove = entries
        .take(max(0, box.length - entriesCount))
        .map((e) => e.key);
    await box.deleteAll(keysToRemove);
    return;
  }
}

class KeySchedule<Id> {
  final Id originalKey;
  final DateTime dateTime;
  KeySchedule(this.originalKey, this.dateTime);

  @override
  String toString() {
    return "${originalKey.toString()}_${dateTime.toString()}";
  }
}

class CacheDataSource extends PassThroughSource {
  HiveCache<Week, KeySchedule<int>> groupScheduleCache;
  HiveCache<Week, KeySchedule<RoomId>> roomScheduleCache;
  HiveCache<Week, KeySchedule<int>> teacherScheduleCache;
  CacheDataSource({
    required super.prevDataSource,
    required this.groupScheduleCache,
    required this.roomScheduleCache,
    required this.teacherScheduleCache,
  });

  @override
  Future<Week> getScheduleByGroup(int groupId, DateTime dayTime) async {
    var val = groupScheduleCache.getValue(KeySchedule(groupId, dayTime));
    if (val == null) {
      var newVal = await prevDataSource.getScheduleByGroup(groupId, dayTime);
      groupScheduleCache.addValue(KeySchedule(groupId, dayTime), newVal);
      return newVal;
    }
    return val;
  }

  @override
  Future<Week> getScheduleByRoom(RoomId roomId, DateTime dayTime) async {
    var val = roomScheduleCache.getValue(KeySchedule(roomId, dayTime));
    if (val == null) {
      var newVal = await prevDataSource.getScheduleByRoom(roomId, dayTime);
      roomScheduleCache.addValue(KeySchedule(roomId, dayTime), newVal);
      return newVal;
    }
    return val;
  }

  @override
  Future<Week> getScheduleByTeacher(int teacherId, DateTime dayTime) async {
    var val = teacherScheduleCache.getValue(KeySchedule(teacherId, dayTime));
    if (val == null) {
      var newVal = await prevDataSource.getScheduleByTeacher(
        teacherId,
        dayTime,
      );
      teacherScheduleCache.addValue(KeySchedule(teacherId, dayTime), newVal);
      return newVal;
    }
    return val;
  }

  @override
  Future<void> invalidateScheduleByGroup(int groupId, DateTime dayTime) async {
    var newVal = await prevDataSource.getScheduleByGroup(groupId, dayTime);
    if (newVal != groupScheduleCache.getValue(KeySchedule(groupId, dayTime))) {
      await groupScheduleCache.addValue(KeySchedule(groupId, dayTime), newVal);
    }
  }

  @override
  Future<void> invalidateScheduleByRoom(RoomId roomId, DateTime dayTime) async {
    var newVal = await prevDataSource.getScheduleByRoom(roomId, dayTime);
    if (newVal != roomScheduleCache.getValue(KeySchedule(roomId, dayTime))) {
      await roomScheduleCache.addValue(KeySchedule(roomId, dayTime), newVal);
    }
  }

  @override
  Future<void> invalidateScheduleByTeacher(
    int teacherId,
    DateTime dayTime,
  ) async {
    var newVal = await prevDataSource.getScheduleByTeacher(teacherId, dayTime);
    if (newVal !=
        teacherScheduleCache.getValue(KeySchedule(teacherId, dayTime))) {
      await teacherScheduleCache.addValue(
        KeySchedule(teacherId, dayTime),
        newVal,
      );
    }
  }
}
