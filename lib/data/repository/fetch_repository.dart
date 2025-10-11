import '../../domain/entities/building.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/repositories/fetch_repository.dart';
import '../data_sources/interface/fetch.dart';

class FetchRepositoryImpl extends FetchRepository {
  final FetchDataSource fetchDataSource;
  const FetchRepositoryImpl({required this.fetchDataSource});

  @override
  Future<List<Group>> findGroups(String query) {
    return fetchDataSource.findGroups(query);
  }

  @override
  Future<List<Teacher>> findTeachers(String query) {
    return fetchDataSource.findTeachers(query);
  }

  @override
  Future<List<Building>> getAllBuildings() {
    return fetchDataSource.getAllBuildings();
  }

  @override
  Future<List<Room>> getAllRoomsOfBuilding(int buildingId) {
    return fetchDataSource.getAllRoomsOfBuilding(buildingId);
  }
}
