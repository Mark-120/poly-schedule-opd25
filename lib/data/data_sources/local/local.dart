import 'package:hive/hive.dart';

import '../../../core/logger.dart';
import '../../../domain/entities/entity.dart';
import '../../../domain/entities/schedule/week.dart';
import '../../../domain/repositories/featured_repository.dart';
import '../../../domain/repositories/settings_repository.dart';
import '../interface/schedule_key.dart';
import '../intermediate/pass_through.dart';

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
  Future<Week> getSchedule(ScheduleKey key) async {
    var val = localBox.get(key.toString());
    if (val != null) {
      logger.debug('[Local] Schedule - LOCAL HIT for $key');
      return val;
    }

    logger.debug('[Local] Schedule - LOCAL MISS for $key');
    return prevDataSource.getSchedule(key);
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
  Future<Week> invalidateSchedule(ScheduleKey key) async {
    logger.debug('[Cache] Schedule - Invalidate for $key');
    return prevDataSource.invalidateSchedule(key);
  }

  //Tries to save schedule in memory/local storage
  @override
  Future<bool> saveSchedule(ScheduleKey key, Week week) async {
    final featured = await featuredRepository.isSavedInFeatured(key.id);
    final isInRange = await isBetween(key.dateTime);

    //Featured are saved on disk
    if (featured && isInRange) {
      await localBox.put(key.toString(), week);
      return true;
    } else {
      return prevDataSource.saveSchedule(key, week);
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
        futures.add(getAndSaveSchedule(ScheduleKey(obj.getId(), i)));
      }
    }
    await Future.wait(futures);
  }

  Future<void> getAndSaveSchedule(ScheduleKey key) async {
    final week = await getSchedule(key);
    //Featured are saved on disk
    await localBox.put(key.toString(), week);
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
