import '../entities/group.dart';
import '../entities/teacher.dart';
import '../entities/room.dart';

abstract class FeaturedRepository {
  Future<List<Teacher>> getFeaturedTeachers();
  Future<void> setFeaturedTeachers(List<Teacher> newTeachers);
  Future<void> addFeaturedTeacher(Teacher newTeacher);

  Future<List<Group>> getFeaturedGroups();
  Future<void> setFeaturedGroups(List<Group> newGroups);
  Future<void> addFeaturedGroup(Group newGroup);

  Future<List<Room>> getFeaturedRooms();
  Future<void> setFeaturedRooms(List<Room> newRooms);
  Future<void> addFeaturedRoom(Room newRoom);
}
