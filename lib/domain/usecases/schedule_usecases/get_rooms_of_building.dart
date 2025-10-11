import '../../entities/room.dart';
import '../../repositories/fetch_repository.dart';

class GetRoomsOfBuilding {
  final FetchRepository repository;

  GetRoomsOfBuilding(this.repository);

  Future<List<Room>> call(int buildingId) async {
    return await repository.getAllRoomsOfBuilding(buildingId);
  }
}
