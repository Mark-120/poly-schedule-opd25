import '../../core/date_formater.dart';
import '../../domain/entities/entity_id.dart';
import '../../domain/entities/schedule/week.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../data_sources/interface/schedule.dart';

class ScheduleRepositoryImpl extends ScheduleRepository {
  final ScheduleDataSource scheduleDataSource;
  const ScheduleRepositoryImpl({required this.scheduleDataSource});

  @override
  Future<Week> getSchedule(EntityId entityId, DateTime dayTime) {
    return scheduleDataSource
        .getSchedule(entityId, DateFormater.truncDate(dayTime))
        .then((x) => x.$1);
  }

  @override
  Future<void> invalidateSchedule(EntityId entityId, DateTime dayTime) {
    return scheduleDataSource.invalidateSchedule(
      entityId,
      DateFormater.truncDate(dayTime),
    );
  }
}
