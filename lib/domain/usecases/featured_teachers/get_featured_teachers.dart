import '../../repositories/featured_repository.dart';
import '../../entities/teacher.dart';

class GetFeaturedTeachers {
  final FeaturedRepository repository;

  GetFeaturedTeachers(this.repository);

  Future<List<Teacher>> call() async {
    return await repository.getFeaturedTeachers();
  }
}
