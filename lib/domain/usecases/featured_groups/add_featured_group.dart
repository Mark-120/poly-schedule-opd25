import '../../repositories/featured_repository.dart';
import '../../entities/group.dart';

class AddFeaturedGroup {
  final FeaturedRepository repository;

  AddFeaturedGroup(this.repository);

  Future<void> call(Group group) async {
    await repository.addFeaturedGroup(group);
  }
}
