import '../../entities/building.dart';
import '../../repositories/fetch_repository.dart';

class GetAllBuildings {
  final FetchRepository repository;

  GetAllBuildings(this.repository);

  Future<List<Building>> call() async {
    return await repository.getAllBuildings();
  }
}
