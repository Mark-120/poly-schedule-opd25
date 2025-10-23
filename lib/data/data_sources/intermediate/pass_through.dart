import '../../../core/date_formater.dart';
import '../../../domain/entities/entity_id.dart';
import '../../../domain/entities/schedule/week.dart';
import '../interface/schedule.dart';

class PassThroughSource extends ScheduleDataSource {
  final ScheduleDataSource prevDataSource;
  PassThroughSource({required this.prevDataSource});

  @override
  Future<(Week, StorageType)> getSchedule(EntityId id, DateTime dayTime) =>
      prevDataSource.getSchedule(id, dayTime);

  @override
  Future<(Week, StorageType)> invalidateSchedule(
    EntityId id,
    DateTime dayTime,
  ) => prevDataSource.invalidateSchedule(id, dayTime);

  @override
  Future<void> removeSchedule(EntityId id, DateTime dayTime) =>
      prevDataSource.removeSchedule(id, dayTime);

  DateTime getCurrentDate() {
    return DateFormater.truncDate(DateTime.now());
  }

  @override
  Future<void> onAppStart() => prevDataSource.onAppStart();

  @override
  Future<void> onFeaturedChanged() => prevDataSource.onFeaturedChanged();
}
