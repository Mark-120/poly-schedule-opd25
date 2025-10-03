import '../../domain/entities/entity_id.dart';
import '../../domain/entities/schedule/week.dart';

abstract class ScheduleDataSource {
  Future<Week> getSchedule(EntityId id, DateTime dayTime);
  Future<void> invalidateSchedule(EntityId id, DateTime dayTime);
}
