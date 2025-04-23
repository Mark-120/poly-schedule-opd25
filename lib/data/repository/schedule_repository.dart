import '../data_sources/base.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/building.dart';
import '../../domain/entities/schedule/week.dart';

class ScheduleRepositoryImpl extends ScheduleRepository {
  static DateTime _truncDate(DateTime input){
    var truncHour = input.subtract((Duration(
      hours: input.hour,
      minutes: input.minute,
      seconds: input.second,
      milliseconds: input.millisecond,
      microseconds: input.microsecond,
    )));
    var truncDay = truncHour.subtract(Duration(days: truncHour.weekday - 1));
    return truncDay;
  }
  static DateTime truncDateTest(DateTime input) => _truncDate(input);

  final DataSource dataSource;
  ScheduleRepositoryImpl(this.dataSource);
  @override
  Future<List<Teacher>> findTeachers(String query) =>
      dataSource.findTeachers(query);

  @override
  Future<List<Group>> findGroups(String query) => dataSource.findGroups(query);
  @override
  Future<List<Building>> getAllBuildings() => dataSource.getAllBuildings();

  @override
  Future<List<Room>> getAllRoomsOfBuilding(int buildingId) async =>
      dataSource.getAllRoomsOfBuilding(buildingId);
  @override
  Future<Week> getScheduleByTeacher(int teacherId, DateTime dayTime) =>
      dataSource.getScheduleByTeacher(teacherId, _truncDate(dayTime));
  @override
  Future<Week> getScheduleByGroup(int groupId, DateTime dayTime) =>
      dataSource.getScheduleByGroup(groupId, _truncDate(dayTime));
  @override
  Future<Week> getScheduleByRoom(RoomId roomId, DateTime dayTime) =>
      dataSource.getScheduleByRoom(roomId, _truncDate(dayTime));
}
