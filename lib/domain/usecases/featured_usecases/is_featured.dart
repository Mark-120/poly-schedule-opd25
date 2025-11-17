import '../../entities/entity_id.dart';
import '../../repositories/featured_repository.dart';

class isSavedInFeatured {
  final FeaturedRepository repository;

  isSavedInFeatured(this.repository);

  Future<bool> call(EntityId id) {
    return repository.isSavedInFeatured(id);
  }
}
