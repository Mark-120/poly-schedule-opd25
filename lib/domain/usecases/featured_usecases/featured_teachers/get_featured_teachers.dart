import '../../../entities/teacher.dart';
import '../../../repositories/featured_repository.dart';

class GetFeaturedTeachers {
  final FeaturedRepository repository;

  GetFeaturedTeachers(this.repository);

  Future<List<Teacher>> call() async {
    return await repository.getFeaturedTeachers();
  }
}
