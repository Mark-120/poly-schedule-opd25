import '../../../domain/entities/building.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/entities/teacher.dart';

abstract class FetchDataSource {
  Future<List<Teacher>> findTeachers(String query);
  Future<List<Group>> findGroups(String query);

  Future<List<Building>> getBuildings(String query);
  Future<List<Room>> getAllRoomsOfBuilding(int buildingId);
}
