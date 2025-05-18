import '../repositories/featured_repository.dart';
import '../entities/room.dart';

class GetFeaturedRooms {
  final FeaturedRepository repository;

  GetFeaturedRooms(this.repository);

  Future<List<Room>> call() async {
    return await repository.getFeaturedRooms();
  }
}
