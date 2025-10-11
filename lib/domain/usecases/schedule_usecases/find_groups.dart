import '../../entities/group.dart';
import '../../repositories/fetch_repository.dart';

class FindGroups {
  final FetchRepository repository;

  FindGroups(this.repository);

  Future<List<Group>> call(String query) async {
    return await repository.findGroups(query);
  }
}
