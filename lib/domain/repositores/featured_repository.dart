import '../entities/group.dart';
import '../entities/teacher.dart';
import '../entities/room.dart';

abstract class FeaturedRepository {
  Future<List<Teacher>> getFeaturedTeachers();
  void setFeaturedTeachers(List<int> newTeacherIds);

  Future<List<Group>> getFeaturedGroups();
  void setFeaturedGroups(List<int> newGroupIds);

  Future<List<Room>> getFeaturedRooms();
  void setFeaturedRooms(List<RoomId> newRoomIds);
}
