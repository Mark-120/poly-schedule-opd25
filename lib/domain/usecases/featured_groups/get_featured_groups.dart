import '../repositories/featured_repository.dart';
import '../entities/group.dart';

class GetFeaturedGroups {
  final FeaturedRepository repository;

  GetFeaturedGroups(this.repository);

  Future<List<Group>> call() async {
    return await repository.getFeaturedGroups();
  }
}