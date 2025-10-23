import 'package:hive/hive.dart';

import '../../../core/logger.dart';
import '../../../domain/entities/entity_id.dart';
import '../../../domain/entities/schedule/week.dart';
import '../../../domain/repositories/featured_repository.dart';
import '../interface/schedule.dart';
import '../intermediate/pass_through.dart';
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

  @override
  Future<void> onAppStart() async {
    removeExtra();
    preLoadFeatured();
    super.onAppStart();
  }

  @override
  Future<void> onFeaturedChanged() async {
    removeExtra();
    preLoadFeatured();
    super.onFeaturedChanged();
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
    final featured = await featuredRepository.isSavedInFeatured(key.id);

    //Featured are saved on disk
    if (schedule.$2 != StorageType.local && featured) {
      if (isBetween(key.dateTime)) {
        final a = localBox.put(key.toString(), schedule.$1);
        final b = prevDataSource.removeSchedule(key.id, key.dateTime);
        await (a, b).wait;
      }
    }
  }

  Future<void> preLoadFeatured() {
    var futures = [
      featuredRepository.getFeaturedGroups().then(
        (list) => preLoadEntity(list, (x) => EntityId.group(x.id)),
      ),
      featuredRepository.getFeaturedRooms().then(
        (list) => preLoadEntity(list, (x) => EntityId.room(x.getId())),
      ),
      featuredRepository.getFeaturedTeachers().then(
        (list) => preLoadEntity(list, (x) => EntityId.teacher(x.id)),
      ),
    ];
    return Future.wait(futures);
  }

  Future<void> preLoadEntity<T>(
    List<T> featured,
    EntityId Function(T) convertToEntityId,
  ) {
    List<Future<void>> futures = [];
    for (final obj in featured) {
      for (
        DateTime i = getMin();
        !i.isAfter(getMax());
        i = i.add(Duration(days: 7))
      ) {
        futures.add(
          retrieveAndSaveSchedule(ScheduleKey(convertToEntityId(obj), i)),
        );
      }
    }
    return Future.wait(futures);
  }

  Future<void> removeExtra() async {
    //TODO: Add real parallel execution
    for (var x in localBox.keys) {
      var isOld = ScheduleKey.parse(x).dateTime.isBefore(getMin());
      var isFeatured = await featuredRepository.isSavedInFeatured(
        ScheduleKey.parse(x).id,
      );
      if (isOld || !isFeatured) {
        logger.debug('[Local] Schedule - Delete from cache key: $x');
        localBox.delete(x);
      }
    }
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
}
