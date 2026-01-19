import '../../../domain/entities/schedule/week.dart';
import 'schedule_key.dart';

enum StorageType { local, memory, remote }

abstract class ScheduleDataSource {
  Future<Week> getSchedule(ScheduleKey key);
  Future<Week> invalidateSchedule(ScheduleKey key);
  //Save schedule in data layer if applicable
  Future<bool> saveSchedule(ScheduleKey key, Week week);

  Future<void> onAppStart();
  Future<void> onFeaturedChanged();
}
