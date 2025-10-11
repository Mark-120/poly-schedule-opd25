import '../../../entities/teacher.dart';
import '../../../repositories/featured_repository.dart';
import '../../../repositories/schedule_repository.dart';

class SetFeaturedTeachers {
  final ScheduleRepository scheduleRepository;
  final FeaturedRepository repository;

  SetFeaturedTeachers(this.repository, this.scheduleRepository);

  Future<void> call(List<Teacher> teachers) async {
    await repository.setFeaturedTeachers(teachers);
    await scheduleRepository.onFeaturedChanged();
  }
}
