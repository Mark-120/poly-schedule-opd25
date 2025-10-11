import '../../../entities/group.dart';
import '../../../repositories/featured_repository.dart';
import '../../../repositories/schedule_repository.dart';

class SetFeaturedGroups {
  final ScheduleRepository scheduleRepository;
  final FeaturedRepository repository;

  SetFeaturedGroups(this.repository, this.scheduleRepository);

  Future<void> call(List<Group> groups) async {
    await repository.setFeaturedGroups(groups);
    await scheduleRepository.onFeaturedChanged();
  }
}
