import '../../../common/usecases/usecase.dart';
import '../../repositories/schedule_repository.dart';

class UpdateKeepingConstraints implements UseCase<void, UpdateConstraintsParams> {
  final ScheduleRepository repository;

  UpdateKeepingConstraints(this.repository);

  @override
  Future<void> call(UpdateConstraintsParams params) async {
    return await repository.updateKeepingConstraints(params.numOfWeeks);
  }
}

class UpdateLoadingConstraints
    implements UseCase<void, UpdateConstraintsParams> {
  final ScheduleRepository repository;

  UpdateLoadingConstraints(this.repository);

  @override
  Future<void> call(UpdateConstraintsParams params) async {
    return await repository.updateLoadingConstraints(params.numOfWeeks);
  }
}

class UpdateConstraintsParams {
  final int numOfWeeks;

  UpdateConstraintsParams({required this.numOfWeeks});
}
