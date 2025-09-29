import '../../../entities/room.dart';
import '../../../repositories/featured_repository.dart';

class AddFeaturedRoom {
  final FeaturedRepository repository;

  AddFeaturedRoom(this.repository);

  Future<void> call(Room room) async {
    await repository.addFeaturedRoom(room);
  }
}
