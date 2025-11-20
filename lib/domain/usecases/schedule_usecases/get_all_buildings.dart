import '../../entities/building.dart';
import '../../entities/featured.dart';
import '../../repositories/fetch_repository.dart';

class GetBuildings {
  final FetchRepository repository;

  GetBuildings(this.repository);

  Future<List<Featured<Building>>> call(String query) async {
    return await repository.getBuildings(query);
  }
}
