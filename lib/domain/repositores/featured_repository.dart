import '../entities/group.dart';
import '../entities/teacher.dart';
import '../entities/room.dart';

abstract class FeaturedRepository {
  Future<List<Teacher>> getFeaturedTeachers();
  void setFeaturedTeachers(List<int> newTeacherIds);
  void addFeaturedTeacher(int newTeacherId);

  Future<List<Group>> getFeaturedGroups();
  void setFeaturedGroups(List<int> newGroupIds);
  void addFeaturedGroup(int newGroupId);

  Future<List<Room>> getFeaturedRooms();
  void setFeaturedRooms(List<RoomId> newRoomIds);
  void addFeaturedRoom(RoomId newRoomId);
}
