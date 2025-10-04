import '../../../core/date_formater.dart';
import '../../../core/exception/remote_exception.dart';
import '../../../domain/entities/entity_id.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/entities/schedule/week.dart';
import '../../models/schedule/week.dart';
import '../interface/schedule.dart';
import 'base_remote.dart';

final class RemoteScheduleDataSourceImpl extends RemoteDataSource
    implements ScheduleDataSource {
  RemoteScheduleDataSourceImpl({required super.client, required super.logger});

  @override
  Future<(Week, StorageType)> getSchedule(EntityId id, DateTime dayTime) async {
    if (id.isTeacher) {
      return getScheduleByTeacher(
        id.asTeacher.id,
        dayTime,
      ).then((x) => (x, StorageType.remote));
    } else if (id.isGroup) {
      return getScheduleByGroup(
        id.asGroup.id,
        dayTime,
      ).then((x) => (x, StorageType.remote));
    } else if (id.isRoom) {
      return getScheduleByRoom(
        id.asRoom,
        dayTime,
      ).then((x) => (x, StorageType.remote));
    }
    throw RemoteException('Invalid Id type');
  }

  Future<Week> getScheduleByTeacher(int teacherId, DateTime dayTime) async {
    final response = await getRespone(
      'teachers/$teacherId/scheduler?date=${DateFormater.getStringFromDayTime(dayTime)}',
    );
    if (response.statusCode == 200) {
      return WeekModel.fromJson(decodeToJson(response));
    } else {
      throw RemoteException(
        'Failed to load schedule from server from teacher $teacherId, date $dayTime',
      );
    }
  }

  Future<Week> getScheduleByGroup(int groupId, DateTime dayTime) async {
    final response = await getRespone(
      'scheduler/$groupId?date=${DateFormater.getStringFromDayTime(dayTime)}',
    );
    if (response.statusCode == 200) {
      return WeekModel.fromJson(decodeToJson(response));
    } else {
      throw RemoteException(
        'Failed to load schedule from server from teacher $groupId, date $dayTime',
      );
    }
  }

  Future<Week> getScheduleByRoom(RoomId roomId, DateTime dayTime) async {
    final response = await getRespone(
      'buildings/${roomId.buildingId}/rooms/${roomId.roomId}/scheduler?date=${DateFormater.getStringFromDayTime(dayTime)}',
    );
    if (response.statusCode == 200) {
      return WeekModel.fromJson(decodeToJson(response));
    } else {
      throw RemoteException(
        'Failed to load schedule from server from room $roomId, date $dayTime',
      );
    }
  }

  @override
  Future<void> invalidateSchedule(EntityId id, DateTime dayTime) async {}

  @override
  Future<void> removeSchedule(EntityId id, DateTime dayTime) async {}
}
