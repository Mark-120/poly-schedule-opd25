import '../entities/featured.dart';

abstract class LastFeaturedRepository {
  Future<void> saveLastFeatured(Featured entity);
  Future<Featured?> getLastFeatured();
}
