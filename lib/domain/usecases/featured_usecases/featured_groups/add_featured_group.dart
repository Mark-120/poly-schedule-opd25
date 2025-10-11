import '../../../entities/group.dart';
import '../../../repositories/featured_repository.dart';
import '../../../repositories/schedule_repository.dart';

class AddFeaturedGroup {
  final ScheduleRepository scheduleRepository;
  final FeaturedRepository repository;

  AddFeaturedGroup(this.repository, this.scheduleRepository);

  Future<void> call(Group group) async {
    await repository.addFeaturedGroup(group);
    await scheduleRepository.onFeaturedChanged();
  }
}
