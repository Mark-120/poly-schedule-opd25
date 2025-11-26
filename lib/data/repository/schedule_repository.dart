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
  Future<Week> invalidateSchedule(EntityId entityId, DateTime dayTime) {
    return scheduleDataSource
        .invalidateSchedule(entityId, DateFormater.truncDate(dayTime))
        .then((val) => val.$1);
  }

  @override
  Future<void> onAppStart() async {
    scheduleDataSource.onAppStart();
  }

  @override
  Future<void> onFeaturedChanged() async {
    scheduleDataSource.onAppStart();
  }

  @override
  Future<void> updateKeepingConstraints(int numOfWeeks) {
    // TODO: implement updateKeepingConstraints
    throw UnimplementedError();
  }

  @override
  Future<void> updateLoadingConstraints(int numOfWeeks) {
    // TODO: implement updateLoadingConstraints
    throw UnimplementedError();
  }
}
