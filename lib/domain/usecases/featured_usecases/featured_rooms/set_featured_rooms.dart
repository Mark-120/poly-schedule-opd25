import '../../../entities/room.dart';
import '../../../repositories/featured_repository.dart';

class SetFeaturedRooms {
  final FeaturedRepository repository;

  SetFeaturedRooms(this.repository);

  Future<void> call(List<Room> rooms) async {
    await repository.setFeaturedRooms(rooms);
  }
}
