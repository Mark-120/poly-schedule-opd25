import '../../../entities/teacher.dart';
import '../../../repositories/featured_repository.dart';
import '../../../repositories/schedule_repository.dart';

class AddFeaturedTeacher {
  final ScheduleRepository scheduleRepository;
  final FeaturedRepository repository;

  AddFeaturedTeacher(this.repository, this.scheduleRepository);

  Future<void> call(Teacher teacher) async {
    await repository.addFeaturedTeacher(teacher);
    await scheduleRepository.onFeaturedChanged();
  }
}
