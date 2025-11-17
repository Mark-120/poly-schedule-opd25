import '../../domain/entities/building.dart';
import '../../domain/entities/featured.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/teacher.dart';
import '../../domain/repositories/featured_repository.dart';
import '../../domain/repositories/fetch_repository.dart';
import '../data_sources/interface/fetch.dart';

class FetchRepositoryImpl extends FetchRepository {
  final FetchDataSource fetchDataSource;
  final FeaturedRepository featuredRepository;
  const FetchRepositoryImpl({
    required this.fetchDataSource,
    required this.featuredRepository,
  });

  @override
  Future<List<Featured<Group>>> findGroups(String query) async {
    final featured = await featuredRepository.getFeaturedGroups();
    final stream = (await fetchDataSource.findGroups(
      query,
    )).map((x) => Featured(x, isFeatured: featured.contains(x)));
    final sorted = [
      ...stream.where((e) => e.isFeatured),
      ...stream.where((e) => !e.isFeatured),
    ];
    return sorted;
  }

  @override
  Future<List<Featured<Teacher>>> findTeachers(String query) async {
    final featured = await featuredRepository.getFeaturedTeachers();
    final stream = (await fetchDataSource.findTeachers(
      query,
    )).map((x) => Featured(x, isFeatured: featured.contains(x)));
    final sorted = [
      ...stream.where((e) => e.isFeatured),
      ...stream.where((e) => !e.isFeatured),
    ];
    return sorted;
  }

  @override
  Future<List<Featured<Building>>> getAllBuildings() async {
    final featured = await featuredRepository.getFeaturedRooms();
    final stream = (await fetchDataSource.getAllBuildings()).map(
      (x) =>
          Featured(x, isFeatured: featured.any((room) => room.building == x)),
    );
    final sorted = [
      ...stream.where((e) => e.isFeatured),
      ...stream.where((e) => !e.isFeatured),
    ];
    return sorted;
  }

  @override
  Future<List<Featured<Room>>> getAllRoomsOfBuilding(int buildingId) async {
    final featured = await featuredRepository.getFeaturedRooms();
    final stream = (await fetchDataSource.getAllRoomsOfBuilding(
      buildingId,
    )).map((x) => Featured(x, isFeatured: featured.contains(x)));
    final sorted = [
      ...stream.where((e) => e.isFeatured),
      ...stream.where((e) => !e.isFeatured),
    ];
    return sorted;
  }
}
