import '../../../core/date_formater.dart';
import '../../../domain/entities/schedule/week.dart';
import '../interface/schedule.dart';
import '../interface/schedule_key.dart';

class PassThroughSource extends ScheduleDataSource {
  final ScheduleDataSource prevDataSource;
  PassThroughSource({required this.prevDataSource});

  @override
  Future<Week> getSchedule(ScheduleKey key) => prevDataSource.getSchedule(key);

  @override
  Future<Week> invalidateSchedule(ScheduleKey key) =>
      prevDataSource.invalidateSchedule(key);

  @override
  Future<bool> saveSchedule(ScheduleKey key, Week week) =>
      prevDataSource.saveSchedule(key, week);

  DateTime getCurrentDate() {
    return DateFormater.truncDate(DateTime.now());
  }

  @override
  Future<void> onAppStart() => prevDataSource.onAppStart();

  @override
  Future<void> onFeaturedChanged() => prevDataSource.onFeaturedChanged();
}
