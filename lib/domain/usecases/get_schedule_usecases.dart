// Для получения расписания группы
import '../../common/usecases/usecase.dart';
import '../entities/room.dart';
import '../entities/schedule/week.dart';
import '../repositories/schedule_repository.dart';

class GetScheduleByGroup implements UseCase<Week, GetScheduleByGroupParams> {
  final ScheduleRepository repository;

  GetScheduleByGroup(this.repository);

  @override
  Future<Week> call(GetScheduleByGroupParams params) async {
    return await repository.getScheduleByGroup(params.groupId, params.dayTime);
  }
}

class GetScheduleByGroupParams {
  final int groupId;
  final DateTime dayTime;

  GetScheduleByGroupParams({required this.groupId, required this.dayTime});
}

class GetScheduleByTeacher
    implements UseCase<Week, GetScheduleByTeacherParams> {
  final ScheduleRepository repository;

  GetScheduleByTeacher(this.repository);

  @override
  Future<Week> call(GetScheduleByTeacherParams params) async {
    return await repository.getScheduleByTeacher(
      params.teacherId,
      params.dayTime,
    );
  }
}

class GetScheduleByTeacherParams {
  final int teacherId;
  final DateTime dayTime;

  GetScheduleByTeacherParams({required this.teacherId, required this.dayTime});
}

class GetScheduleByRoom implements UseCase<Week, GetScheduleByRoomParams> {
  final ScheduleRepository repository;

  GetScheduleByRoom(this.repository);

  @override
  Future<Week> call(GetScheduleByRoomParams params) async {
    return await repository.getScheduleByRoom(params.roomId, params.dayTime);
  }
}

class GetScheduleByRoomParams {
  final RoomId roomId;
  final DateTime dayTime;

  GetScheduleByRoomParams({required this.roomId, required this.dayTime});
}
