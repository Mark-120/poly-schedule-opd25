import 'package:http/http.dart';
import 'dart:convert';

import 'base.dart';
import '../models/schedule/week.dart';
import '../../core/logger.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/schedule/week.dart';
import '../../core/date_formater.dart';
import '../../core/exception/remote_exception.dart';

class RemoteScheduleDataSourceImpl implements ScheduleDataSource {
  final Client client;
  final AppLogger logger;
  RemoteScheduleDataSourceImpl({required this.client, required this.logger});

  //All responses uses utf8 as coding, so it's necessary to decode appropriatly
  Map<String, dynamic> _decodeToJson(Response response) {
    return json.decode(utf8.decode(response.bodyBytes));
  }

  @override
  Future<Week> getSchedule(EntityId id, DateTime dayTime) async {
    if (id.isTeacher) {
      return getScheduleByTeacher(id.asTeacher.id, dayTime);
    } else if (id.isGroup) {
      return getScheduleByGroup(id.asGroup.id, dayTime);
    } else if (id.isRoom) {
      return getScheduleByRoom(id.asRoom, dayTime);
    }
    throw RemoteException("Invalid Id type");
  }

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
  Future<Week> invalidateSchedule(EntityId id, DateTime dayTime) async {
    // Return new data from server
    return getSchedule(id, dayTime);
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
