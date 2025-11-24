import '../../domain/entities/featured.dart';
import '../../domain/usecases/last_featured_usecases/save_last_featured.dart';

class LastScheduleService {
  final SaveLastFeatured saveLastSchedule;
  final GetLastSchedule getLastSchedule;

  LastScheduleService({
    required this.saveLastSchedule,
    required this.getLastSchedule,
  });

  Future<void> save({required Featured featured}) async {
    await saveLastSchedule(featured: featured);
  }

  Future<Featured?> load() async {
    return await getLastSchedule();
  }
}
