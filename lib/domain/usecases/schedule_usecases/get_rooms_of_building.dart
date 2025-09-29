import '../../entities/room.dart';
import '../../repositories/schedule_repository.dart';

class GetRoomsOfBuilding {
  final ScheduleRepository repository;

  GetRoomsOfBuilding(this.repository);

  Future<List<Room>> call(int buildingId) async {
    return await repository.getAllRoomsOfBuilding(buildingId);
  }
}
