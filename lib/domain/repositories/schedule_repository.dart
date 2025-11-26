import '../entities/entity_id.dart';
import '../entities/schedule/week.dart';

abstract class ScheduleRepository {
  const ScheduleRepository();
  Future<Week> getSchedule(EntityId entityId, DateTime dayTime);

  Future<Week> invalidateSchedule(EntityId entityId, DateTime dayTime);

  Future<void> updateLoadingConstraints(int numOfWeeks);
  Future<void> updateKeepingConstraints(int numOfWeeks);

  Future<void> onAppStart();
  Future<void> onFeaturedChanged();
}
