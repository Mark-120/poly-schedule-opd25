import '../../entities/group.dart';
import '../../repositories/schedule_repository.dart';

class FindGroups {
  final ScheduleRepository repository;

  FindGroups(this.repository);

  Future<List<Group>> call(String query) async {
    return await repository.findGroups(query);
  }
}
