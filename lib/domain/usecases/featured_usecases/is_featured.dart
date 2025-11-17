import '../../entities/entity_id.dart';
import '../../repositories/featured_repository.dart';

class IsSavedInFeatured {
  final FeaturedRepository repository;

  IsSavedInFeatured(this.repository);

  Future<bool> call(EntityId id) {
    return repository.isSavedInFeatured(id);
  }
}
