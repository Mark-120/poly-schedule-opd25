import 'package:hive/hive.dart';

import '../../../core/logger.dart';
import '../../../domain/entities/entity.dart';
import '../../../domain/entities/entity_id.dart';
import '../../../domain/entities/schedule/week.dart';
import '../../../domain/repositories/featured_repository.dart';
import '../../../domain/repositories/settings_repository.dart';
import '../interface/schedule.dart';
import '../intermediate/pass_through.dart';
import 'schedule_key.dart';

final class LocalDataSource extends PassThroughSource {
  final AppLogger logger;
  final FeaturedRepository featuredRepository;
  final SettingsRepository settingsRepository;
  final Box<Week> localBox;

  LocalDataSource({
    required super.prevDataSource,
    required this.featuredRepository,
    required this.settingsRepository,
    required this.localBox,
    required this.logger,
  });

  @override
  Future<(Week, StorageType)> getSchedule(EntityId id, DateTime dayTime) async {
    return retrieveAndSaveSchedule(ScheduleKey(id, dayTime));
  }

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

  @override
  Future<(Week, StorageType)> invalidateSchedule(
    EntityId id,
    DateTime dayTime,
  ) async {
    var newSchedule = await prevDataSource.invalidateSchedule(id, dayTime);
    logger.debug(
      '[Cache] Schedule - Invalidate for ${ScheduleKey(id, dayTime)}',
    );
    saveSchedule(ScheduleKey(id, dayTime), newSchedule);
    return newSchedule;
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

  //Tries to save schedule in memory/local storage
  Future<void> saveSchedule(
    ScheduleKey key,
    (Week, StorageType) schedule,
  ) async {
    final featured = await featuredRepository.isSavedInFeatured(key.id);

    //Featured are saved on disk
    if (schedule.$2 != StorageType.local && featured) {
      if (await isBetween(key.dateTime)) {
        final a = localBox.put(key.toString(), schedule.$1);
        final b = prevDataSource.removeSchedule(key.id, key.dateTime);
        await (a, b).wait;
      }
    }
  }

  Future<void> preLoadFeatured() {
    var futures = [
      featuredRepository.getFeaturedGroups().then(
        (list) => preLoadEntity(list),
      ),
      featuredRepository.getFeaturedRooms().then((list) => preLoadEntity(list)),
      featuredRepository.getFeaturedTeachers().then(
        (list) => preLoadEntity(list),
      ),
    ];
    return Future.wait(futures);
  }

  Future<void> preLoadEntity(List<ScheduleEntity> featured) async {
    List<Future<void>> futures = [];
    for (final obj in featured) {
      for (
        DateTime i = await getMin();
        !i.isAfter(await getMax());
        i = i.add(Duration(days: 7))
      ) {
        futures.add(retrieveAndSaveSchedule(ScheduleKey(obj.getId(), i)));
      }
    }
    await Future.wait(futures);
  }

  Future<void> removeExtra() async {
    await Future.wait(
      localBox.keys.map((x) async {
        final key = ScheduleKey.parse(x);
        final isOld = key.dateTime.isBefore(await getMin());

        final isFeatured = await featuredRepository.isSavedInFeatured(key.id);

        if (isOld || !isFeatured) {
          logger.debug('[Local] Schedule - Delete from cache key: $x');
          await localBox.delete(x);
        }
      }),
    );
  }

  Future<DateTime> getMin() async {
    return getCurrentDate().subtract(
      Duration(days: await settingsRepository.getKeepingConstraints() * 7),
    );
  }

  Future<DateTime> getMax() async {
    return getCurrentDate().add(
      Duration(days: await settingsRepository.getLoadingConstraints() * 7),
    );
  }

  Future<bool> isBetween(DateTime time) async {
    return !time.isAfter(await getMax()) && !time.isBefore(await getMin());
  }
}
