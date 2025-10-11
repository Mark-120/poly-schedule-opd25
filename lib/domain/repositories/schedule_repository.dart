import '../entities/entity_id.dart';
import '../entities/schedule/week.dart';

abstract class ScheduleRepository {
  const ScheduleRepository();
  Future<Week> getSchedule(EntityId entityId, DateTime dayTime);

  Future<void> invalidateSchedule(EntityId entityId, DateTime dayTime);
}
