import '../entities/building.dart';
import '../entities/group.dart';
import '../entities/room.dart';
import '../entities/teacher.dart';

abstract class FetchRepository {
  const FetchRepository();
  Future<List<Teacher>> findTeachers(String query);
  Future<List<Group>> findGroups(String query);

  Future<List<Building>> getAllBuildings();
  Future<List<Room>> getAllRoomsOfBuilding(int buildingId);
}
