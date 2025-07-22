import 'dart:math';
import "package:hive/hive.dart";
import 'package:poly_scheduler/core/logger.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/schedule/week.dart';
import 'base.dart';

class HiveCache<T, K> {
  final AppLogger logger;
  int entriesCount;
  Box<(T, DateTime)> box;

  HiveCache({required this.box, this.entriesCount = 30, required this.logger});

  T? getValue(K key) {
    final value = box.get(key.toString());
    logger.debug(
      '[Cache] GET ${key.toString()} - ${value != null ? 'HIT' : 'MISS'}',
    );
    return value?.$1;
  }

  Future<void> addValue(K key, T value) async {
    logger.debug('[Cache] SET ${key.toString()}');
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
    logger.debug('[Cache] CLEAN removing ${keysToRemove.length} old entries');
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
  final AppLogger logger;
  HiveCache<Week, KeySchedule<int>> groupScheduleCache;
  HiveCache<Week, KeySchedule<RoomId>> roomScheduleCache;
  HiveCache<Week, KeySchedule<int>> teacherScheduleCache;
  CacheDataSource({
    required super.prevDataSource,
    required this.groupScheduleCache,
    required this.roomScheduleCache,
    required this.teacherScheduleCache,
    required this.logger,
  });

  @override
  Future<Week> getScheduleByGroup(int groupId, DateTime dayTime) async {
    final cacheKey = KeySchedule(groupId, dayTime);
    logger.debug('[Cache] ScheduleByGroup - checking cache for $cacheKey');
    var val = groupScheduleCache.getValue(KeySchedule(groupId, dayTime));
    if (val == null) {
      logger.debug('[Cache] ScheduleByGroup - CACHE MISS for $cacheKey');
      var newVal = await prevDataSource.getScheduleByGroup(groupId, dayTime);
      groupScheduleCache.addValue(KeySchedule(groupId, dayTime), newVal);
      return newVal;
    }
    logger.debug('[Cache] ScheduleByGroup - CACHE HIT for $cacheKey');
    return val;
  }

  @override
  Future<Week> getScheduleByRoom(RoomId roomId, DateTime dayTime) async {
    final cacheKey = KeySchedule(roomId, dayTime);
    logger.debug('[Cache] ScheduleByRoom - checking cache for $cacheKey');
    var val = roomScheduleCache.getValue(cacheKey);
    if (val == null) {
      logger.debug('[Cache] ScheduleByRoom - CACHE MISS for $cacheKey');
      var newVal = await prevDataSource.getScheduleByRoom(roomId, dayTime);
      roomScheduleCache.addValue(KeySchedule(roomId, dayTime), newVal);
      return newVal;
    }
    logger.debug('[Cache] ScheduleByRoom - CACHE HIT for $cacheKey');
    return val;
  }

  @override
  Future<Week> getScheduleByTeacher(int teacherId, DateTime dayTime) async {
    final cacheKey = KeySchedule(teacherId, dayTime);
    logger.debug('[Cache] ScheduleByTeacher - checking cache for $cacheKey');
    var val = teacherScheduleCache.getValue(cacheKey);
    if (val == null) {
      logger.debug('[Cache] ScheduleByTeacher - CACHE MISS for $cacheKey');
      var newVal = await prevDataSource.getScheduleByTeacher(
        teacherId,
        dayTime,
      );
      teacherScheduleCache.addValue(KeySchedule(teacherId, dayTime), newVal);
      return newVal;
    }
    logger.debug('[Cache] ScheduleByTeacher - CACHE HIT for $cacheKey');
    return val;
  }

  @override
  Future<void> invalidateScheduleByGroup(int groupId, DateTime dayTime) async {
    logger.debug('[Cache] ScheduleByGroup - invalidating $groupId at $dayTime');
    var newVal = await prevDataSource.getScheduleByGroup(groupId, dayTime);
    if (newVal != groupScheduleCache.getValue(KeySchedule(groupId, dayTime))) {
      logger.debug('[Cache] ScheduleByGroup - data changed, updating cache');
      await groupScheduleCache.addValue(KeySchedule(groupId, dayTime), newVal);
    } else {
      logger.debug(
        '[Cache] ScheduleByGroup - data didn\'t change, no need to update cache',
      );
    }
  }

  @override
  Future<void> invalidateScheduleByRoom(RoomId roomId, DateTime dayTime) async {
    logger.debug('[Cache] ScheduleByRoom - invalidating $roomId at $dayTime');
    var newVal = await prevDataSource.getScheduleByRoom(roomId, dayTime);
    if (newVal != roomScheduleCache.getValue(KeySchedule(roomId, dayTime))) {
      logger.debug('[Cache] ScheduleByRoom - data changed, updating cache');
      await roomScheduleCache.addValue(KeySchedule(roomId, dayTime), newVal);
    } else {
      logger.debug(
        '[Cache] ScheduleByRoom - data didn\'t change, no need to update cache',
      );
    }
  }

  @override
  Future<void> invalidateScheduleByTeacher(
    int teacherId,
    DateTime dayTime,
  ) async {
    logger.debug(
      '[Cache] ScheduleByTeacher - invalidating $teacherId at $dayTime',
    );
    var newVal = await prevDataSource.getScheduleByTeacher(teacherId, dayTime);
    if (newVal !=
        teacherScheduleCache.getValue(KeySchedule(teacherId, dayTime))) {
      logger.debug('[Cache] ScheduleByTeacher - data changed, updating cache');
      await teacherScheduleCache.addValue(
        KeySchedule(teacherId, dayTime),
        newVal,
      );
    } else {
      logger.debug(
        '[Cache] ScheduleByTeacher - data didn\'t change, no need to update cache',
      );
    }
  }
}
