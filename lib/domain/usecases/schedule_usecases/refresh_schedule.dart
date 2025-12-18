import '../../../common/usecases/usecase.dart';
import '../../entities/entity_id.dart';
import '../../entities/schedule/week.dart';
import '../../repositories/schedule_repository.dart';

class RefreshSchedule implements UseCase<Week, RefreshScheduleParams> {
  final ScheduleRepository repository;

  RefreshSchedule(this.repository);

  @override
  Future<Week> call(RefreshScheduleParams params) async {
    return await repository.invalidateSchedule(params.entityId, params.dayTime);
  }
}

class RefreshScheduleParams {
  final EntityId entityId;
  final DateTime dayTime;

  RefreshScheduleParams({required this.entityId, required this.dayTime});
}
