import '../../../entities/teacher.dart';
import '../../../repositories/featured_repository.dart';

class AddFeaturedTeacher {
  final FeaturedRepository repository;

  AddFeaturedTeacher(this.repository);

  Future<void> call(Teacher teacher) async {
    await repository.addFeaturedTeacher(teacher);
  }
}
