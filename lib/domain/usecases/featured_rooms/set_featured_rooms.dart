import '../../repositories/featured_repository.dart';
import '../../entities/room.dart';

class SetFeaturedRooms {
  final FeaturedRepository repository;

  SetFeaturedRooms(this.repository);

  Future<void> call(List<Room> rooms) async {
    await repository.setFeaturedRooms(rooms);
  }
}
