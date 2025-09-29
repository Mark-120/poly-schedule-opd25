import '../../../entities/group.dart';
import '../../../repositories/featured_repository.dart';

class AddFeaturedGroup {
  final FeaturedRepository repository;

  AddFeaturedGroup(this.repository);

  Future<void> call(Group group) async {
    await repository.addFeaturedGroup(group);
  }
}
