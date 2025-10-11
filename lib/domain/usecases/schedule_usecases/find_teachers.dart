import '../../entities/teacher.dart';
import '../../repositories/fetch_repository.dart';

class FindTeachers {
  final FetchRepository repository;

  FindTeachers(this.repository);

  Future<List<Teacher>> call(String query) async {
    return await repository.findTeachers(query);
  }
}
