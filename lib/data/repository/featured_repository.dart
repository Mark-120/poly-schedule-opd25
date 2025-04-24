import '../data_sources/featured.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/repositories/featured_repository.dart';

class FeaturedRepositoryImpl implements FeaturedRepository {
  FeaturedDataSource dataSource;
  FeaturedRepositoryImpl({required this.dataSource});
  @override
  Future<void> addFeaturedGroup(Group newGroup) =>
      dataSource.addFeaturedGroup(newGroup);

  @override
  Future<void> addFeaturedRoom(Room newRoomI) =>
      dataSource.addFeaturedRoom(newRoom);

  @override
  Future<void> addFeaturedTeacher(Teacher newTeacher) =>
      dataSource.addFeaturedTeacher(newTeacher);

  @override
  Future<List<Group>> getFeaturedGroups() => dataSource.getFeaturedGroups();

  @override
  Future<List<Room>> getFeaturedRooms() => dataSource.getFeaturedRooms();

  @override
  Future<List<Teacher>> getFeaturedTeachers() =>
      dataSource.getFeaturedTeachers();

  @override
  Future<void> setFeaturedGroups(List<Group> newGroups) =>
      dataSource.setFeaturedGroups(newGroups);

  @override
  Future<void> setFeaturedRooms(List<Room> newRooms) =>
      dataSource.setFeaturedRooms(newRooms);

  @override
  Future<void> setFeaturedTeachers(List<Teacher> newTeachers) =>
      dataSource.setFeaturedTeachers(newTeachers);
}
