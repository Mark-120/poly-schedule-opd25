// domain/usecases/last_schedule_usecases.dart

import '../../../data/models/last_schedule.dart';
import '../../repositories/last_schedule_repository.dart';

class SaveLastSchedule {
  final LastScheduleRepository repository;

  SaveLastSchedule(this.repository);

  Future<void> call({
    required String type,
    required String id,
    required String title,
  }) async {
    await repository.saveLastSchedule(
      LastSchedule(
        type: type,
        id: id,
        title: title,
        lastOpened: DateTime.now(),
      ),
    );
  }
}

class GetLastSchedule {
  final LastScheduleRepository repository;

  GetLastSchedule(this.repository);

  Future<LastSchedule?> call() async {
    return await repository.getLastSchedule();
  }
}
