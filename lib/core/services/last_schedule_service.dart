import '../../data/models/last_schedule.dart';
import '../../domain/entities/entity_id.dart';
import '../../domain/usecases/last_schedule_usecases/save_last_schedule.dart';

class LastScheduleService {
  final SaveLastSchedule saveLastSchedule;
  final GetLastSchedule getLastSchedule;

  LastScheduleService({
    required this.saveLastSchedule,
    required this.getLastSchedule,
  });

  Future<void> save({required EntityId id, required String title}) async {
    await saveLastSchedule(id: id, title: title);
  }

  Future<LastSchedule?> load() async {
    return await getLastSchedule();
  }
}
