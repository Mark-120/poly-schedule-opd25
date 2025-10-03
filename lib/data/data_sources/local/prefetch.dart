import '../../../domain/entities/entity_id.dart';
import '../../../domain/entities/schedule/week.dart';
import '../pass_through.dart';
import '../schedule.dart';

final class PrefetchDataSource extends PassThroughSource {
  int prefetchSize;
  PrefetchDataSource({
    required super.prevDataSource,
    required this.prefetchSize,
  });
  @override
  Future<(Week, StorageType)> getSchedule(EntityId id, DateTime dayTime) {
    //Prefetch data
    for (var i = 1; i < prefetchSize; i++) {
      prevDataSource.getSchedule(id, dayTime.add(Duration(days: 7 * i)));
    }
    return prevDataSource.getSchedule(id, dayTime);
  }
}
