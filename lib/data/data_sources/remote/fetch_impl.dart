import '../../../core/exception/remote_exception.dart';
import '../../../domain/entities/building.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/entities/teacher.dart';
import '../../models/building.dart';
import '../../models/group.dart';
import '../../models/room.dart';
import '../../models/teacher.dart';
import '../interface/fetch.dart';
import 'base_remote.dart';

final class FetchRemoteDataSourceImpl extends RemoteDataSource
    implements FetchDataSource {
  FetchRemoteDataSourceImpl({required super.client, required super.logger});

  @override
  Future<List<Teacher>> findTeachers(String query) async {
    final response = await getRespone('search/teachers?q=$query');
    if (response.statusCode == 200) {
      return (decodeToJson(response)['teachers'] as List<dynamic>)
          .map((teacher) => TeacherModel.fromJson(teacher))
          .toList();
    } else {
      throw RemoteException(
        'Failed to load teachers from server query is $query',
      );
    }
  }

  @override
  Future<List<Group>> findGroups(String query) async {
    final response = await getRespone('search/groups?q=$query');
    if (response.statusCode == 200) {
      return (decodeToJson(response)['groups'] as List<dynamic>)
          .map((group) => GroupModel.fromJson(group))
          .toList();
    } else {
      throw RemoteException(
        'Failed to load groups from server, query is $query',
      );
    }
  }

  @override
  Future<List<Building>> getAllBuildings() async {
    final response = await getRespone('buildings');
    if (response.statusCode == 200) {
      final buildings =
          (decodeToJson(response)['buildings'] as List<dynamic>)
              .map((group) => BuildingModel.fromJson(group))
              .toList();

      buildings.sort((a, b) {
        return a.name.compareTo(b.name);
      });

      return buildings;
    } else {
      throw RemoteException('Failed to load buildings from server');
    }
  }

  @override
  Future<List<Room>> getAllRoomsOfBuilding(int building) async {
    final response = await getRespone('buildings/$building/rooms');
    if (response.statusCode == 200) {
      var json = decodeToJson(response);
      final rooms =
          (json['rooms'] as List<dynamic>)
              .map(
                (room) => RoomModel.fromJsonAndBuilding(
                  room,
                  BuildingModel.fromJson(json['building']),
                ),
              )
              .toList();

      rooms.sort((a, b) {
        return a.name.compareTo(b.name);
      });

      return rooms;
    } else {
      throw RemoteException(
        'Failed to load rooms from server from building $building',
      );
    }
  }
}
