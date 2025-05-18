import '../repositories/featured_repository.dart';
import '../entities/teacher.dart';

class AddFeaturedTeacher {
  final FeaturedRepository repository;

  AddFeaturedTeacher(this.repository);

  Future<void> call(Teacher teacher) async {
    await repository.addFeaturedTeacher(teacher);
  }
}
