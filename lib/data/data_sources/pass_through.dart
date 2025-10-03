import '../../domain/entities/entity_id.dart';
import '../../domain/entities/schedule/week.dart';
import 'schedule.dart';

class PassThroughSource extends ScheduleDataSource {
  final ScheduleDataSource prevDataSource;
  PassThroughSource({required this.prevDataSource});

  @override
  Future<Week> getSchedule(EntityId id, DateTime dayTime) =>
      prevDataSource.getSchedule(id, dayTime);

  @override
  Future<void> invalidateSchedule(EntityId id, DateTime dayTime) =>
      prevDataSource.invalidateSchedule(id, dayTime);
}
