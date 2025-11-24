// domain/usecases/last_schedule_usecases.dart

import '../../entities/featured.dart';
import '../../repositories/last_featured_repository.dart';

class SaveLastFeatured {
  final LastFeaturedRepository repository;

  SaveLastFeatured(this.repository);

  Future<void> call({required Featured featured}) async {
    await repository.saveLastFeatured(featured);
  }
}

class GetLastSchedule {
  final LastFeaturedRepository repository;

  GetLastSchedule(this.repository);

  Future<Featured?> call() async {
    return await repository.getLastFeatured();
  }
}
