import '../../../common/usecases/usecase.dart';
import '../../repositories/schedule_repository.dart';
import '../../repositories/settings_repository.dart';

class UpdateKeepingConstraints
    implements UseCase<void, UpdateConstraintsParams> {
  final SettingsRepository repository;
  final ScheduleRepository scheduleRepository;

  UpdateKeepingConstraints(this.repository, this.scheduleRepository);

  @override
  Future<void> call(UpdateConstraintsParams params) async {
    await repository.updateKeepingConstraints(params.numOfWeeks);
    scheduleRepository.onFeaturedChanged();
    return;
  }
}

class UpdateLoadingConstraints
    implements UseCase<void, UpdateConstraintsParams> {
  final SettingsRepository repository;
  final ScheduleRepository scheduleRepository;

  UpdateLoadingConstraints(this.repository, this.scheduleRepository);

  @override
  Future<void> call(UpdateConstraintsParams params) async {
    await repository.updateLoadingConstraints(params.numOfWeeks);
    scheduleRepository.onFeaturedChanged();
    return;
  }
}

class GetKeepingConstraints {
  final SettingsRepository repository;

  GetKeepingConstraints(this.repository);

  Future<UpdateConstraintsParams> call() {
    return repository.getKeepingConstraints().then(
      (x) => UpdateConstraintsParams(numOfWeeks: x),
    );
  }
}

class GetLoadingConstraints {
  final SettingsRepository repository;

  GetLoadingConstraints(this.repository);

  Future<UpdateConstraintsParams> call() {
    return repository.getLoadingConstraints().then(
      (x) => UpdateConstraintsParams(numOfWeeks: x),
    );
  }
}

class UpdateConstraintsParams {
  final int numOfWeeks;

  UpdateConstraintsParams({required this.numOfWeeks});
}
