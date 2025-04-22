import 'package:http/http.dart';
import 'dart:convert';

import '../models/teacher.dart';
import '../models/group.dart';
import '../models/room.dart';
import '../models/building.dart';
import '../models/schedule/week.dart';
import '../../domain/entities/room.dart';

class RemoteDataSourceImpl {
  final Client client;
  RemoteDataSourceImpl({required this.client});

  //All responses uses utf8 as coding, so it's necessary to decode appropriatly
  Map<String, dynamic> decodeToJson(Response response) {
    return json.decode(utf8.decode(response.bodyBytes));
  }

  Future<List<TeacherModel>> findTeachers(String query) async {
    final response = await client.get(
      Uri.parse('https://ruz.spbstu.ru/api/v1/ruz/search/teachers?q=$query'),
    );
    if (response.statusCode == 200) {
      return (decodeToJson(response)['teachers'] as List<dynamic>)
          .map((teacher) => TeacherModel.fromJson(teacher))
          .toList();
    } else {
      throw Exception('Failed to load teachers from server');
    }
  }

  Future<List<GroupModel>> findGroups(String query) async {
    final response = await client.get(
      Uri.parse('https://ruz.spbstu.ru/api/v1/ruz/search/groups?q=$query'),
    );
    if (response.statusCode == 200) {
      return (decodeToJson(response)["groups"] as List<dynamic>)
          .map((group) => GroupModel.fromJson(group))
          .toList();
    } else {
      throw Exception('Failed to load groups from server');
    }
  }

  Future<List<BuildingModel>> getAllBuildings() async {
    final response = await client.get(
      Uri.parse('https://ruz.spbstu.ru/api/v1/ruz/buildings'),
    );
    if (response.statusCode == 200) {
      return (decodeToJson(response)['buildings'] as List<dynamic>)
          .map((group) => BuildingModel.fromJson(group))
          .toList();
    } else {
      throw Exception('Failed to load buildings from server');
    }
  }

  Future<List<RoomModel>> getAllRoomsOfBuilding(BuildingModel building) async {
    final response = await client.get(
      Uri.parse(
        'https://ruz.spbstu.ru/api/v1/ruz/buildings/${building.id}/rooms',
      ),
    );
    if (response.statusCode == 200) {
      return (decodeToJson(response)["rooms"] as List<dynamic>)
          .map((room) => RoomModel.fromJsonAndBuilding(room, building))
          .toList();
    } else {
      throw Exception(
        'Failed to load rooms from server from building ${building.id}',
      );
    }
  }

  String getStringFromDayTime(DateTime dayTime) {
    return '${dayTime.year}-${dayTime.month}-${dayTime.day}';
  }

  Future<WeekModel> getScheduleByTeacher(
    int teacherId,
    DateTime dayTime,
  ) async {
    final response = await client.get(
      Uri.parse(
        'https://ruz.spbstu.ru/api/v1/ruz/teachers/$teacherId/scheduler?date=${getStringFromDayTime(dayTime)}',
      ),
    );
    if (response.statusCode == 200) {
      return WeekModel.fromJson(decodeToJson(response));
    } else {
      throw Exception(
        'Failed to load schedule from server from teacher $teacherId, date $dayTime',
      );
    }
  }

  Future<WeekModel> getScheduleByGroup(int groupId, DateTime dayTime) async {
    final response = await client.get(
      Uri.parse(
        'https://ruz.spbstu.ru/api/v1/ruz/scheduler/$groupId?date=${getStringFromDayTime(dayTime)}',
      ),
    );
    if (response.statusCode == 200) {
      return WeekModel.fromJson(decodeToJson(response));
    } else {
      throw Exception(
        'Failed to load schedule from server from teacher $groupId, date $dayTime',
      );
    }
  }

  Future<WeekModel> getScheduleByRoom(RoomId roomId, DateTime dayTime) async {
    final response = await client.get(
      Uri.parse(
        'ttps://ruz.spbstu.ru/api/v1/ruz/buildings/${roomId.buildingId}/rooms/${roomId.roomId}/scheduler?date=${getStringFromDayTime(dayTime)}',
      ),
    );
    if (response.statusCode == 200) {
      return WeekModel.fromJson(decodeToJson(response));
    } else {
      throw Exception(
        'Failed to load schedule from server from room $roomId, date $dayTime',
      );
    }
  }
}
