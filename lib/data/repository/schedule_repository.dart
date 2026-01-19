import '../../core/date_formater.dart';
import '../../domain/entities/entity_id.dart';
import '../../domain/entities/schedule/week.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../data_sources/interface/schedule.dart';
import '../data_sources/interface/schedule_key.dart';

class ScheduleRepositoryImpl extends ScheduleRepository {
  final ScheduleDataSource scheduleDataSource;
  const ScheduleRepositoryImpl({required this.scheduleDataSource});

  @override
  Future<Week> getSchedule(EntityId entityId, DateTime dayTime) async {
    final key = ScheduleKey(entityId, DateFormater.truncDate(dayTime));
    final week = await scheduleDataSource.getSchedule(key);
    scheduleDataSource.saveSchedule(key, week);
    return week;
  }

  @override
  Future<Week> invalidateSchedule(EntityId entityId, DateTime dayTime) async {
    final key = ScheduleKey(entityId, DateFormater.truncDate(dayTime));
    final week = await scheduleDataSource.invalidateSchedule(key);
    scheduleDataSource.saveSchedule(key, week);
    return week;
  }

  @override
  Future<void> onAppStart() async {
    scheduleDataSource.onAppStart();
  }

  @override
  Future<void> onFeaturedChanged() async {
    scheduleDataSource.onAppStart();
  }
}
