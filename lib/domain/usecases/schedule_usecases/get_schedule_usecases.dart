// Для получения расписания группы

import '../../../common/usecases/usecase.dart';
import '../../entities/entity_id.dart';
import '../../entities/group.dart';
import '../../entities/room.dart';
import '../../entities/schedule/week.dart';
import '../../entities/teacher.dart';
import '../../repositories/schedule_repository.dart';

class GetSchedule implements UseCase<Week, GetScheduleParams> {
  final ScheduleRepository repository;

  GetSchedule(this.repository);

  @override
  Future<Week> call(GetScheduleParams params) async {
    return await repository.getSchedule(params.entityId, params.dayTime);
  }
}

class GetScheduleParams {
  final EntityId entityId;
  final DateTime dayTime;

  GetScheduleParams({required this.entityId, required this.dayTime});
}
