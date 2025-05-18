import '../repositories/featured_repository.dart';
import '../entities/teacher.dart';

class SetFeaturedTeachers {
  final FeaturedRepository repository;

  SetFeaturedTeachers(this.repository);

  Future<void> call(List<Teacher> teachers) async {
    await repository.setFeaturedTeachers(teachers);
  }
}
