import '../../repositories/schedule_repository.dart';

class OnAppStart {
  final ScheduleRepository repository;

  OnAppStart(this.repository);

  Future<void> call() async {
    return await repository.onAppStart();
  }
}
