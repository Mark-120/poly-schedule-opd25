import '../../entities/building.dart';
import '../../entities/featured.dart';
import '../../repositories/fetch_repository.dart';

class GetAllBuildings {
  final FetchRepository repository;

  GetAllBuildings(this.repository);

  Future<List<Featured<Building>>> call() async {
    return await repository.getAllBuildings();
  }
}
