import '../../entities/teacher.dart';
import '../../repositories/schedule_repository.dart';

class FindTeachers {
  final ScheduleRepository repository;

  FindTeachers(this.repository);

  Future<List<Teacher>> call(String query) async {
    return await repository.findTeachers(query);
  }
}
