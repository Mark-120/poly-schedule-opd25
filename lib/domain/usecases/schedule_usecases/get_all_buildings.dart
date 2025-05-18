import '../../entities/building.dart';
import '../../repositories/schedule_repository.dart';

class GetAllBuildings {
  final ScheduleRepository repository;

  GetAllBuildings(this.repository);

  Future<List<Building>> call() async {
    return await repository.getAllBuildings();
  }
}
