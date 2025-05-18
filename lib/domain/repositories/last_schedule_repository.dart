import '../../data/models/last_schedule.dart';

abstract class LastScheduleRepository {
  Future<void> saveLastSchedule(LastSchedule schedule);
  Future<LastSchedule?> getLastSchedule();
}
