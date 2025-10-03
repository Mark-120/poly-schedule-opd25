import '../../domain/entities/entity_id.dart';
import '../../domain/entities/schedule/week.dart';

enum StorageType { local, memory, remote }

abstract class ScheduleDataSource {
  Future<(Week, StorageType)> getSchedule(EntityId id, DateTime dayTime);
  Future<void> invalidateSchedule(EntityId id, DateTime dayTime);
}
