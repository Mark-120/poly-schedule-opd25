import '../../../entities/teacher.dart';
import '../../../repositories/featured_repository.dart';

class SetFeaturedTeachers {
  final FeaturedRepository repository;

  SetFeaturedTeachers(this.repository);

  Future<void> call(List<Teacher> teachers) async {
    await repository.setFeaturedTeachers(teachers);
  }
}
