import '../../../core/date_formater.dart';
import '../../../core/exception/remote_exception.dart';
import '../../../domain/entities/entity_id.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/entities/schedule/week.dart';
import '../../../domain/entities/teacher.dart';
import '../../models/schedule/week.dart';
import '../interface/schedule.dart';
import '../interface/schedule_key.dart';
import 'base_remote.dart';

final class RemoteScheduleDataSourceImpl extends RemoteDataSource
    implements ScheduleDataSource {
  RemoteScheduleDataSourceImpl({required super.client, required super.logger});

  @override
  Future<Week> getSchedule(ScheduleKey key) async {
    final id = key.id;
    if (id is TeacherId) {
      return getScheduleByTeacher(id, key.dateTime);
    } else if (id is GroupId) {
      return getScheduleByGroup(id, key.dateTime);
    } else if (id is RoomId) {
      return getScheduleByRoom(id, key.dateTime);
    }

    return throw (RemoteException('Invalid Id type'));
  }

  Future<Week> getScheduleByTeacher(
    TeacherId teacherId,
    DateTime dayTime,
  ) async {
    final response = await getRespone(
      'teachers/$teacherId/scheduler?date=${DateFormater.getStringFromDayTime(dayTime)}',
    );
    if (response.statusCode != 200) {
      return throw (
        RemoteException(
          'Failed to load schedule from server from teacher $teacherId, date $dayTime',
        ),
      );
    }
    return WeekModel.fromJson(decodeToJson(response));
  }

  Future<Week> getScheduleByGroup(GroupId groupId, DateTime dayTime) async {
    final response = await getRespone(
      'scheduler/$groupId?date=${DateFormater.getStringFromDayTime(dayTime)}',
    );

    if (response.statusCode != 200) {
      return throw (
        RemoteException(
          'Failed to load schedule from server from teacher $groupId, date $dayTime',
        ),
      );
    }

    return WeekModel.fromJson(decodeToJson(response));
  }

  Future<Week> getScheduleByRoom(RoomId roomId, DateTime dayTime) async {
    final response = await getRespone(
      'buildings/${roomId.buildingId}/rooms/${roomId.roomId}/scheduler?date=${DateFormater.getStringFromDayTime(dayTime)}',
    );

    if (response.statusCode != 200) {
      return throw (
        RemoteException(
          'Failed to load schedule from server from room $roomId, date $dayTime',
        ),
      );
    }
    return WeekModel.fromJson(decodeToJson(response));
  }

  @override
  Future<Week> invalidateSchedule(ScheduleKey key) => getSchedule(key);

  @override
  Future<bool> saveSchedule(ScheduleKey key, Week week) async {
    return false;
  }

  @override
  Future<void> onAppStart() async {}

  @override
  Future<void> onFeaturedChanged() async {}
}
