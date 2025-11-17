import '../entities/building.dart';
import '../entities/featured.dart';
import '../entities/group.dart';
import '../entities/room.dart';
import '../entities/teacher.dart';

abstract class FetchRepository {
  const FetchRepository();
  Future<List<Featured<Teacher>>> findTeachers(String query);
  Future<List<Featured<Group>>> findGroups(String query);

  Future<List<Featured<Building>>> getAllBuildings();
  Future<List<Featured<Room>>> getAllRoomsOfBuilding(int buildingId);
}
