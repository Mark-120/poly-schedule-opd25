import '../../../core/logger.dart';
import '../../../domain/entities/schedule/week.dart';
import '../interface/schedule_key.dart';
import '../intermediate/pass_through.dart';
import 'hive_cache.dart';

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
  Future<Week> getSchedule(ScheduleKey key) async {
    final memory = memoryCache[key];

    if (memory != null) {
      logger.debug('[Cache] Schedule - MEMORY CACHE HIT for $key');
      return memory;
    }

    var val = localBox.getValue(key);
    if (val != null) {
      logger.debug('[Cache] Schedule - CACHE HIT for $key');
      return val;
    }

    logger.debug('[Cache] Schedule - CACHE MISS for $key');
    return prevDataSource.getSchedule(key);
  }

  @override
  Future<Week> invalidateSchedule(ScheduleKey key) async {
    logger.debug('[Cache] Schedule - Invalidate for $key');
    return prevDataSource.invalidateSchedule(key);
  }

  @override
  Future<bool> saveSchedule(ScheduleKey key, Week week) async {
    logger.debug('[Cache] Schedule - Save for $key');

    if (isBetween(key.dateTime)) {
      localBox.addValue(key, week);
      memoryCache.remove(key);
      return true;
    }
    memoryCache[key] = week;
    return prevDataSource.saveSchedule(key, week);
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
