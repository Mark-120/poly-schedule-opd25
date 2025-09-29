import '../../../entities/group.dart';
import '../../../repositories/featured_repository.dart';

class SetFeaturedGroups {
  final FeaturedRepository repository;

  SetFeaturedGroups(this.repository);

  Future<void> call(List<Group> groups) async {
    await repository.setFeaturedGroups(groups);
  }
}
