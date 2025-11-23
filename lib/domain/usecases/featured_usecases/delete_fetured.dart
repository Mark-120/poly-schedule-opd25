import '../../entities/entity_id.dart';
import '../../repositories/featured_repository.dart';

class DeleteFeatured {
  final FeaturedRepository repository;

  DeleteFeatured(this.repository);

  Future<void> call(EntityId id) {
    return repository.deleteFeatured(id);
  }
}
