import '../entities/group.dart';
import '../entities/teacher.dart';
import '../entities/room.dart';

abstract class FeaturedRepository {
  Future<List<Teacher>> getFeaturedTeachers();
  Future<void> setFeaturedTeachers(List<int> newTeacherIds);
  Future<void> addFeaturedTeacher(int newTeacherId);

  Future<List<Group>> getFeaturedGroups();
  Future<void> setFeaturedGroups(List<int> newGroupIds);
  Future<void> addFeaturedGroup(int newGroupId);

  Future<List<Room>> getFeaturedRooms();
  Future<void> setFeaturedRooms(List<RoomId> newRoomIds);
  Future<void> addFeaturedRoom(RoomId newRoomId);
}
