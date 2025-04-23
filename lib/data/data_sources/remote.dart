import 'package:http/http.dart';
import 'dart:convert';

import '../models/teacher.dart';
import '../models/group.dart';
import '../models/room.dart';
import '../models/building.dart';
import '../models/schedule/week.dart';
import '../../domain/entities/room.dart';

import 'base.dart';

class RemoteDataSourceImpl implements DataSource {
  final Client client;
  RemoteDataSourceImpl({required this.client});

  //All responses uses utf8 as coding, so it's necessary to decode appropriatly
  Map<String, dynamic> _decodeToJson(Response response) {
    return json.decode(utf8.decode(response.bodyBytes));
  }

  @override
  Future<List<TeacherModel>> findTeachers(String query) async {
    final response = await client.get(
      Uri.parse('https://ruz.spbstu.ru/api/v1/ruz/search/teachers?q=$query'),
    );
    if (response.statusCode == 200) {
      return (_decodeToJson(response)['teachers'] as List<dynamic>)
          .map((teacher) => TeacherModel.fromJson(teacher))
          .toList();
    } else {
      throw Exception('Failed to load teachers from server query is $query');
    }
  }

  @override
  Future<List<GroupModel>> findGroups(String query) async {
    final response = await client.get(
      Uri.parse('https://ruz.spbstu.ru/api/v1/ruz/search/groups?q=$query'),
    );
    if (response.statusCode == 200) {
      return (_decodeToJson(response)['groups'] as List<dynamic>)
          .map((group) => GroupModel.fromJson(group))
          .toList();
    } else {
      throw Exception('Failed to load groups from server, query is $query');
    }
  }

  @override
  Future<List<BuildingModel>> getAllBuildings() async {
    final response = await client.get(
      Uri.parse('https://ruz.spbstu.ru/api/v1/ruz/buildings'),
    );
    if (response.statusCode == 200) {
      return (_decodeToJson(response)['buildings'] as List<dynamic>)
          .map((group) => BuildingModel.fromJson(group))
          .toList();
    } else {
      throw Exception('Failed to load buildings from server');
    }
  }

  @override
  Future<List<RoomModel>> getAllRoomsOfBuilding(int building) async {
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
      throw Exception(
        'Failed to load rooms from server from building $building',
      );
    }
  }

  String _getStringFromDayTime(DateTime dayTime) {
    return '${dayTime.year}-${dayTime.month}-${dayTime.day}';
  }

  @override
  Future<WeekModel> getScheduleByTeacher(
    int teacherId,
    DateTime dayTime,
  ) async {
    final response = await client.get(
      Uri.parse(
        'https://ruz.spbstu.ru/api/v1/ruz/teachers/$teacherId/scheduler?date=${_getStringFromDayTime(dayTime)}',
      ),
    );
    if (response.statusCode == 200) {
      return WeekModel.fromJson(_decodeToJson(response));
    } else {
      throw Exception(
        'Failed to load schedule from server from teacher $teacherId, date $dayTime',
      );
    }
  }

  @override
  Future<WeekModel> getScheduleByGroup(int groupId, DateTime dayTime) async {
    final response = await client.get(
      Uri.parse(
        'https://ruz.spbstu.ru/api/v1/ruz/scheduler/$groupId?date=${_getStringFromDayTime(dayTime)}',
      ),
    );
    if (response.statusCode == 200) {
      return WeekModel.fromJson(_decodeToJson(response));
    } else {
      throw Exception(
        'Failed to load schedule from server from teacher $groupId, date $dayTime',
      );
    }
  }

  @override
  Future<WeekModel> getScheduleByRoom(RoomId roomId, DateTime dayTime) async {
    final response = await client.get(
      Uri.parse(
        'ttps://ruz.spbstu.ru/api/v1/ruz/buildings/${roomId.buildingId}/rooms/${roomId.roomId}/scheduler?date=${_getStringFromDayTime(dayTime)}',
      ),
    );
    if (response.statusCode == 200) {
      return WeekModel.fromJson(_decodeToJson(response));
    } else {
      throw Exception(
        'Failed to load schedule from server from room $roomId, date $dayTime',
      );
    }
  }

  @override
  Future<GroupModel> getGroup(int groupId) async {
    final response = await client.get(
      Uri.parse('https://ruz.spbstu.ru/api/v1/ruz/groups/${groupId}'),
    );
    if (response.statusCode == 200) {
      return GroupModel.fromJson(_decodeToJson(response));
    } else {
      throw Exception(
        'Failed to load teacher info from server from teacher $groupId',
      );
    }
  }

  @override
  Future<RoomModel> getRoom(RoomId roomId) async {
    return (await getAllRoomsOfBuilding(
      roomId.buildingId,
    )).firstWhere((x) => x.id == roomId.roomId);
  }

  @override
  Future<TeacherModel> getTeacher(int teacherId) async {
    final response = await client.get(
      Uri.parse('https://ruz.spbstu.ru/api/v1/ruz/teachers/$teacherId'),
    );
    if (response.statusCode == 200) {
      return TeacherModel.fromJson(_decodeToJson(response));
    } else {
      throw Exception(
        'Failed to load teacher info from server from teacher $teacherId',
      );
    }
  }
}
