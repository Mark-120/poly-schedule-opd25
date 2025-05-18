import '../repositories/featured_repository.dart';
import '../entities/group.dart';

class SetFeaturedGroups {
  final FeaturedRepository repository;

  SetFeaturedGroups(this.repository);

  Future<void> call(List<Group> groups) async {
    await repository.setFeaturedGroups(groups);
  }
}