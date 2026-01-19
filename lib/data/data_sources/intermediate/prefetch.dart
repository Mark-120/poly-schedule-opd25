import '../../../domain/entities/schedule/week.dart';
import '../interface/schedule_key.dart';
import 'pass_through.dart';

final class PrefetchDataSource extends PassThroughSource {
  final int prefetchSize;
  PrefetchDataSource({
    required super.prevDataSource,
    required this.prefetchSize,
  });
  @override
  Future<Week> getSchedule(ScheduleKey key) {
    //Prefetch data
    for (var i = 1; i < prefetchSize; i++) {
      final prefetchKey = ScheduleKey(
        key.id,
        key.dateTime.add(Duration(days: 7 * i)),
      );
      prefetchSchedule(prefetchKey);
    }
    return prevDataSource.getSchedule(key);
  }

  Future<void> prefetchSchedule(ScheduleKey key) async {
    final week = await prevDataSource.getSchedule(key);
    await prevDataSource.saveSchedule(key, week);
  }
}
