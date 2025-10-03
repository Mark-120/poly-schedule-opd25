import 'package:hive/hive.dart';

import '../../../core/exception/local_exception.dart';
import '../../../core/logger.dart';
import '../../../domain/entities/entity_id.dart';
import '../../../domain/entities/schedule/week.dart';
import '../../../domain/repositories/featured_repository.dart';
import '../pass_through.dart';
import '../schedule.dart';
import 'schedule_key.dart';

final class LocalDataSource extends PassThroughSource {
  final AppLogger logger;
  final FeaturedRepository featuredRepository;
  final Box<Week> localBox;

  LocalDataSource({
    required super.prevDataSource,
    required this.featuredRepository,
    required this.localBox,
    required this.logger,
  });

  @override
  Future<(Week, StorageType)> getSchedule(EntityId id, DateTime dayTime) async {
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
    var val = localBox.get(cacheKey.toString());
    if (val != null) {
      logger.debug('[Local] Schedule - LOCAL HIT for $cacheKey');
      return (val, StorageType.local);
    }

    logger.debug('[Local] Schedule - LOCAL MISS for $cacheKey');
    return prevDataSource.getSchedule(cacheKey.id, cacheKey.dateTime);
  }

  //Save schedule in memory/local storage
  Future<void> saveSchedule(
    ScheduleKey key,
    (Week, StorageType) schedule,
  ) async {
    final featured = await isSavedInFeatured(key.id);

    //Featured are saved on disk
    if (schedule.$2 != StorageType.local && featured) {
      if (isBetween(key.dateTime)) {
        final a = localBox.put(key, schedule.$1);
        final b = prevDataSource.removeSchedule(key.id, key.dateTime);
        await (a, b).wait;
      }
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

  DateTime getMin() {
    return getCurrentDate().subtract(Duration(days: 7));
  }

  DateTime getMax() {
    return getCurrentDate().add(Duration(days: 28));
  }

  bool isBetween(DateTime time) {
    return !time.isAfter(getMax()) && !time.isBefore(getMin());
  }

  Future<void> preload() async {}
}
