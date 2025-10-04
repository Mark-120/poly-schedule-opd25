import '../../../core/logger.dart';
import '../../../domain/entities/entity_id.dart';
import '../../../domain/entities/schedule/week.dart';
import '../interface/schedule.dart';
import 'hive_cache.dart';
import 'pass_through.dart';
import 'schedule_key.dart';

final class CacheDataSource extends PassThroughSource {
  final AppLogger logger;
  final HiveCache<Week, ScheduleKey> localBox;
  final Map<ScheduleKey, Week> memoryCache = {};

  CacheDataSource({
    required super.prevDataSource,
    required this.localBox,
    required this.logger,
  });

  @override
  Future<(Week, StorageType)> getSchedule(EntityId id, DateTime dayTime) async {
    return retrieveAndSaveSchedule(ScheduleKey(id, dayTime));
  }

  @override
  Future<void> invalidateSchedule(EntityId id, DateTime dayTime) async {
    final cacheKey = ScheduleKey(id, dayTime);
    logger.debug('[Cache] Schedule - Invalidate for $cacheKey');
    final value = prevDataSource.getSchedule(cacheKey.id, cacheKey.dateTime);
    saveSchedule(cacheKey, await value);
  }

  @override
  Future<void> removeSchedule(EntityId id, DateTime dayTime) async {
    final cacheKey = ScheduleKey(id, dayTime);
    logger.debug('[Cache] Schedule - Remove for $cacheKey');

    memoryCache.remove(cacheKey);
    localBox.removeValue(cacheKey);
  }

  Future<(Week, StorageType)> retrieveAndSaveSchedule(
    ScheduleKey cacheKey,
  ) async {
    final schedule = await retrieveSchedule(cacheKey);
    saveSchedule(cacheKey, schedule);
    return schedule;
  }

  //Get Data from memory/local storage/remote connection
  Future<(Week, StorageType)> retrieveSchedule(ScheduleKey cacheKey) async {
    final memory = memoryCache[cacheKey];

    if (memory != null) {
      logger.debug('[Cache] Schedule - MEMORY CACHE HIT for $cacheKey');
      return (memory, StorageType.memory);
    }

    var val = localBox.getValue(cacheKey);
    if (val != null) {
      logger.debug('[Cache] Schedule - CACHE HIT for $cacheKey');
      return (val, StorageType.local);
    }

    logger.debug('[Cache] Schedule - CACHE MISS for $cacheKey');
    return prevDataSource.getSchedule(cacheKey.id, cacheKey.dateTime);
  }

  //Save schedule in memory/local storage
  Future<void> saveSchedule(
    ScheduleKey key,
    (Week, StorageType) schedule,
  ) async {
    if (schedule.$2 != StorageType.local) {
      if (isBetween(key.dateTime)) {
        localBox.addValue(key, schedule.$1);
        prevDataSource.removeSchedule(key.id, key.dateTime);
        memoryCache.remove(key);
        return;
      }
    }
    memoryCache[key] = schedule.$1;
  }

  DateTime getMin() {
    return getCurrentDate().subtract(Duration(days: 7));
  }

  DateTime getMax() {
    return getCurrentDate().add(Duration(days: 14));
  }

  bool isBetween(DateTime time) {
    return !time.isAfter(getMax()) && !time.isBefore(getMin());
  }

  Future<void> preload() async {}
}
