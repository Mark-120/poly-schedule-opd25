import '../../../domain/entities/entity_id.dart';
import '../../../domain/entities/schedule/week.dart';

enum StorageType { local, memory, remote }

abstract class ScheduleDataSource {
  Future<(Week, StorageType)> getSchedule(EntityId id, DateTime dayTime);
  Future<void> invalidateSchedule(EntityId id, DateTime dayTime);
  //Notify data source that it's data stored in another layer, and can be deleted
  Future<void> removeSchedule(EntityId id, DateTime dayTime);
}
