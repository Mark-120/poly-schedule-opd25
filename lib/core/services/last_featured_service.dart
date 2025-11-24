import '../../domain/entities/featured.dart';
import '../../domain/usecases/last_featured_usecases/save_last_featured.dart';

class LastFeaturedService {
  final SaveLastFeatured saveLastFeatured;
  final GetLastFeatured getLastFeatured;

  LastFeaturedService({
    required this.saveLastFeatured,
    required this.getLastFeatured,
  });

  Future<void> save({required Featured featured}) async {
    await saveLastFeatured(featured: featured);
  }

  Future<Featured?> load() async {
    return await getLastFeatured();
  }
}
