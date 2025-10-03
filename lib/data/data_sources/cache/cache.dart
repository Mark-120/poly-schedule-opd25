import 'package:hive/hive.dart';

import '../../../core/date_formater.dart';
import '../../../core/exception/local_exception.dart';
import '../../../core/logger.dart';
import '../../../domain/entities/entity_id.dart';
import '../../../domain/entities/schedule/week.dart';
import '../../../domain/repositories/featured_repository.dart';
import '../pass_through.dart';
import '../schedule.dart';
import 'schedule_key.dart';

final class CacheDataSource extends PassThroughSource {
  AppLogger logger;
  FeaturedRepository featuredRepository;
  Box<Week> localBox;
  Map<ScheduleKey, Week> memoryCache = {};

  CacheDataSource({
    required super.prevDataSource,
    required this.featuredRepository,
    required this.localBox,
    required this.logger,
  });

  DateTime getCurrentDate() {
    return DateFormater.truncDate(DateTime.now());
  }

  @override
  Future<(Week, StorageType)> getSchedule(EntityId id, DateTime dayTime) async {
    //Prefetch data
    retrieveAndSaveSchedule(ScheduleKey(id, dayTime.add(Duration(days: 7))));
    retrieveAndSaveSchedule(ScheduleKey(id, dayTime.add(Duration(days: 14))));

    return retrieveAndSaveSchedule(ScheduleKey(id, dayTime));
  }

  @override
  Future<void> invalidateSchedule(EntityId id, DateTime dayTime) async {}

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

    var val = localBox.get(cacheKey.toString());
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
    final featured = await isSavedInFeatured(key.id);
    //Featured saved on disk
    if (schedule.$2 != StorageType.local && featured) {
      if (isBetween(key.dateTime, featured)) {
        localBox.put(key, schedule.$1);
        return;
      }
    }
    //Non featured saved on disk
    //TODO - make removing of old values
    if (schedule.$2 == StorageType.remote && !featured) {
      if (isBetween(key.dateTime, featured)) {
        localBox.put(key.toString(), schedule.$1);
        return;
      }
    }
    //Non featured saved in memory
    //TODO - make removing of old values
    if (schedule.$2 == StorageType.remote) {
      memoryCache[key] = schedule.$1;
    }
  }

  Future<bool> isSavedInFeatured(EntityId id) async {
    if (id.isTeacher) {
      return (await featuredRepository.getFeaturedGroups()).any(
        (x) => x.id == id.asTeacher,
      );
    } else if (id.isRoom) {
      return (await featuredRepository.getFeaturedRooms()).any(
        (x) => x.getId() == id.asRoom,
      );
    } else if (id.isGroup) {
      return (await featuredRepository.getFeaturedGroups()).any(
        (x) => x.id == id.asGroup,
      );
    }
    return throw LocalException('non valid id');
  }

  DateTime getMin(bool featured) {
    return getCurrentDate().subtract(Duration(days: 7) * 1);
  }

  DateTime getMax(bool featured) {
    return getCurrentDate().add(Duration(days: 7) * (featured ? 4 : 2));
  }

  bool isBetween(DateTime time, bool featured) {
    return !time.isAfter(getMax(featured)) && !time.isBefore(getMin(featured));
  }

  Future<void> preload() async {}
}
