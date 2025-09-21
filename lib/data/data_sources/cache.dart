import 'dart:math';
import "package:hive/hive.dart";
import 'package:poly_scheduler/core/logger.dart';
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

class KeySchedule {
  final EntityId originalKey;
  final DateTime dateTime;
  KeySchedule(this.originalKey, this.dateTime);

  @override
  String toString() {
    return "${originalKey.toString()}_${dateTime.toString()}";
  }
}

class CacheDataSource extends PassThroughSource {
  final AppLogger logger;
  HiveCache<Week, KeySchedule> scheduleCache;
  CacheDataSource({
    required super.prevDataSource,
    required this.scheduleCache,
    required this.logger,
  });

  @override
  Future<Week> getSchedule(EntityId id, DateTime dayTime) async {
    final cacheKey = KeySchedule(id, dayTime);
    logger.debug('[Cache] ScheduleByTeacher - checking cache for $cacheKey');
    var val = scheduleCache.getValue(cacheKey);

    if (val == null) {
      logger.debug('[Cache] ScheduleByTeacher - CACHE MISS for $cacheKey');
      var newVal = await prevDataSource.getSchedule(id, dayTime);
      scheduleCache.addValue(KeySchedule(id, dayTime), newVal);
      return newVal;
    }
    logger.debug('[Cache] ScheduleByTeacher - CACHE HIT for $cacheKey');
    return val;
  }

  @override
  Future<void> invalidateSchedule(EntityId id, DateTime dayTime) async {
    logger.debug('[Cache] ScheduleByTeacher - invalidating $id at $dayTime');
    var newVal = await prevDataSource.getSchedule(id, dayTime);

    if (newVal != scheduleCache.getValue(KeySchedule(id, dayTime))) {
      logger.debug('[Cache] ScheduleByTeacher - data changed, updating cache');
      await scheduleCache.addValue(KeySchedule(id, dayTime), newVal);
    } else {
      logger.debug(
        '[Cache] ScheduleByTeacher - data didn\'t change, no need to update cache',
      );
    }
  }
}
