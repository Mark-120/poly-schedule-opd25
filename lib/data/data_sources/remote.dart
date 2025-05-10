import 'package:http/http.dart';
import 'dart:convert';

import '../models/teacher.dart';
import '../models/group.dart';
import '../models/room.dart';
import '../models/building.dart';
import '../models/schedule/week.dart';
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
  RemoteDataSourceImpl({required this.client});

  //All responses uses utf8 as coding, so it's necessary to decode appropriatly
  Map<String, dynamic> _decodeToJson(Response response) {
    return json.decode(utf8.decode(response.bodyBytes));
  }

  @override
  Future<List<Teacher>> findTeachers(String query) async {
    final response = await client.get(
      Uri.parse('https://ruz.spbstu.ru/api/v1/ruz/search/teachers?q=$query'),
    );
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
    final response = await client.get(
      Uri.parse('https://ruz.spbstu.ru/api/v1/ruz/search/groups?q=$query'),
    );
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
    final response = await client.get(
      Uri.parse('https://ruz.spbstu.ru/api/v1/ruz/buildings'),
    );
    if (response.statusCode == 200) {
      return (_decodeToJson(response)['buildings'] as List<dynamic>)
          .map((group) => BuildingModel.fromJson(group))
          .toList();
    } else {
      throw RemoteException('Failed to load buildings from server');
    }
  }

  @override
  Future<List<Room>> getAllRoomsOfBuilding(int building) async {
    final response = await client.get(
      Uri.parse('https://ruz.spbstu.ru/api/v1/ruz/buildings/$building/rooms'),
    );
    if (response.statusCode == 200) {
      var json = _decodeToJson(response);
      return (json['rooms'] as List<dynamic>)
          .map(
            (room) => RoomModel.fromJsonAndBuilding(
              room,
              BuildingModel.fromJson(json['building']),
            ),
          )
          .toList();
    } else {
      throw RemoteException(
        'Failed to load rooms from server from building $building',
      );
    }
  }

  @override
  Future<Week> getScheduleByTeacher(int teacherId, DateTime dayTime) async {
    final response = await client.get(
      Uri.parse(
        'https://ruz.spbstu.ru/api/v1/ruz/teachers/$teacherId/scheduler?date=${DateFormater.getStringFromDayTime(dayTime)}',
      ),
    );
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
    final response = await client.get(
      Uri.parse(
        'https://ruz.spbstu.ru/api/v1/ruz/scheduler/$groupId?date=${DateFormater.getStringFromDayTime(dayTime)}',
      ),
    );
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
    final response = await client.get(
      Uri.parse(
        'ttps://ruz.spbstu.ru/api/v1/ruz/buildings/${roomId.buildingId}/rooms/${roomId.roomId}/scheduler?date=${DateFormater.getStringFromDayTime(dayTime)}',
      ),
    );
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
}
