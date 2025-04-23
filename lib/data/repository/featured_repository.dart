import '../data_sources/featured.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/repositories/featured_repository.dart';

class FeaturedRepositoryImpl implements FeaturedRepository {
  FeaturedDataSource dataSource;
  FeaturedRepositoryImpl({required this.dataSource});
  @override
  Future<void> addFeaturedGroup(int newGroupId) =>
      dataSource.addFeaturedGroup(newGroupId);

  @override
  Future<void> addFeaturedRoom(RoomId newRoomId) =>
      dataSource.addFeaturedRoom(newRoomId);

  @override
  Future<void> addFeaturedTeacher(int newTeacherId) =>
      dataSource.addFeaturedTeacher(newTeacherId);

  @override
  Future<List<Group>> getFeaturedGroups() => dataSource.getFeaturedGroups();

  @override
  Future<List<Room>> getFeaturedRooms() => dataSource.getFeaturedRooms();

  @override
  Future<List<Teacher>> getFeaturedTeachers() =>
      dataSource.getFeaturedTeachers();

  @override
  Future<void> setFeaturedGroups(List<int> newGroupIds) =>
      dataSource.setFeaturedGroups(newGroupIds);

  @override
  Future<void> setFeaturedRooms(List<RoomId> newRoomIds) =>
      dataSource.setFeaturedRooms(newRoomIds);

  @override
  Future<void> setFeaturedTeachers(List<int> newTeacherIds) =>
      dataSource.setFeaturedTeachers(newTeacherIds);
}
