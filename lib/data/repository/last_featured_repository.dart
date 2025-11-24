import 'package:hive/hive.dart';

import '../../core/logger.dart';
import '../../domain/entities/featured.dart';
import '../../domain/repositories/last_featured_repository.dart';

class LastFeaturedRepositoryImpl implements LastFeaturedRepository {
  final Box box;
  final AppLogger logger;

  LastFeaturedRepositoryImpl(this.box, {required this.logger});

  @override
  Future<Featured?> getLastFeatured() async {
    logger.debug('[Cache] Featured - GET');
    return box.get('last_featured') as Featured?;
  }

  @override
  Future<void> saveLastFeatured(Featured entity) async {
    logger.debug('[Cache] Featured - SET $entity');
    await box.put('last_featured', entity);
  }
}
