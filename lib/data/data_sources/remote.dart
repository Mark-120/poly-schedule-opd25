import 'package:http/http.dart';
import 'dart:convert';

import '../models/teacher.dart';
import '../models/group.dart';
import '../models/room.dart';
import '../models/building.dart';
import '../models/schedule/week.dart';
import '../../core/logger.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/building.dart';
import '../../domain/entities/schedule/week.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../core/date_formater.dart';
import '../../core/exception/remote_exception.dart';

class RemoteDataSourceImpl implements ScheduleRepository {
  final Client client;
  final AppLogger logger;
  RemoteDataSourceImpl({required this.client, required this.logger});

  //All responses uses utf8 as coding, so it's necessary to decode appropriatly
  Map<String, dynamic> _decodeToJson(Response response) {
    return json.decode(utf8.decode(response.bodyBytes));
  }

  @override
  Future<List<Teacher>> findTeachers(String query) async {
    final endpoint =
        'https://ruz.spbstu.ru/api/v1/ruz/search/teachers?q=$query';
    _logEndpointCall(endpoint);
    final response = await client.get(Uri.parse(endpoint));
    _logEndpointResult(endpoint, response);
    if (response.statusCode == 200) {
      return (_decodeToJson(response)['teachers'] as List<dynamic>)
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
    final endpoint = 'https://ruz.spbstu.ru/api/v1/ruz/search/groups?q=$query';
    _logEndpointCall(endpoint);
    final response = await client.get(Uri.parse(endpoint));
    _logEndpointResult(endpoint, response);
    if (response.statusCode == 200) {
      return (_decodeToJson(response)['groups'] as List<dynamic>)
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
    final endpoint = 'https://ruz.spbstu.ru/api/v1/ruz/buildings';
    _logEndpointCall(endpoint);
    final response = await client.get(Uri.parse(endpoint));
    _logEndpointResult(endpoint, response);
    if (response.statusCode == 200) {
      final buildings =
          (_decodeToJson(response)['buildings'] as List<dynamic>)
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
    final endpoint =
        'https://ruz.spbstu.ru/api/v1/ruz/buildings/$building/rooms';
    _logEndpointCall(endpoint);
    final response = await client.get(Uri.parse(endpoint));
    _logEndpointResult(endpoint, response);
    if (response.statusCode == 200) {
      var json = _decodeToJson(response);
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

  @override
  Future<Week> getScheduleByTeacher(int teacherId, DateTime dayTime) async {
    final endpoint =
        'https://ruz.spbstu.ru/api/v1/ruz/teachers/$teacherId/scheduler?date=${DateFormater.getStringFromDayTime(dayTime)}';
    _logEndpointCall(endpoint);
    final response = await client.get(Uri.parse(endpoint));
    _logEndpointResult(endpoint, response);
    if (response.statusCode == 200) {
      return WeekModel.fromJson(_decodeToJson(response));
    } else {
      throw RemoteException(
        'Failed to load schedule from server from teacher $teacherId, date $dayTime',
      );
    }
  }

  @override
  Future<Week> getScheduleByGroup(int groupId, DateTime dayTime) async {
    final endpoint =
        'https://ruz.spbstu.ru/api/v1/ruz/scheduler/$groupId?date=${DateFormater.getStringFromDayTime(dayTime)}';
    _logEndpointCall(endpoint);
    final response = await client.get(Uri.parse(endpoint));
    _logEndpointResult(endpoint, response);
    if (response.statusCode == 200) {
      return WeekModel.fromJson(_decodeToJson(response));
    } else {
      throw RemoteException(
        'Failed to load schedule from server from teacher $groupId, date $dayTime',
      );
    }
  }

  @override
  Future<Week> getScheduleByRoom(RoomId roomId, DateTime dayTime) async {
    final endpoint =
        'https://ruz.spbstu.ru/api/v1/ruz/buildings/${roomId.buildingId}/rooms/${roomId.roomId}/scheduler?date=${DateFormater.getStringFromDayTime(dayTime)}';
    _logEndpointCall(endpoint);
    final response = await client.get(Uri.parse(endpoint));
    _logEndpointResult(endpoint, response);
    if (response.statusCode == 200) {
      return WeekModel.fromJson(_decodeToJson(response));
    } else {
      throw RemoteException(
        'Failed to load schedule from server from room $roomId, date $dayTime',
      );
    }
  }

  @override
  Future<void> invalidateScheduleByGroup(int groupId, DateTime dayTime) async {
    // Do nothing
  }

  @override
  Future<void> invalidateScheduleByRoom(RoomId roomId, DateTime dayTime) async {
    // Do nothing
  }

  @override
  Future<void> invalidateScheduleByTeacher(
    int teacherId,
    DateTime dayTime,
  ) async {
    // Do nothing
  }

  void _logEndpointCall(String endpoint) {
    logger.debug(
      'Called an endpoint: $endpoint',
      stackTrace: StackTrace.current,
    );
  }

  void _logEndpointResult(String endpoint, Response response) {
    if (response.statusCode == 200) {
      logger.debug('Endpoint: $endpoint\nResponse: ${response.statusCode}');
    } else {
      logger.error(
        'Endpoint: $endpoint\nResponse: ${response.statusCode}\nBody:${response.body}',
      );
    }
  }
}
