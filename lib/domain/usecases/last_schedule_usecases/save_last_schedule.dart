// domain/usecases/last_schedule_usecases.dart

import '../../../data/models/last_schedule.dart';
import '../../entities/entity_id.dart';
import '../../repositories/last_schedule_repository.dart';

class SaveLastSchedule {
  final LastScheduleRepository repository;

  SaveLastSchedule(this.repository);

  Future<void> call({required EntityId id, required String title}) async {
    await repository.saveLastSchedule(
      LastSchedule(id: id, title: title, lastOpened: DateTime.now()),
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
