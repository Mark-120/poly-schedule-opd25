import '../../../repositories/featured_repository.dart';
import '../../../entities/room.dart';

class AddFeaturedRoom {
  final FeaturedRepository repository;

  AddFeaturedRoom(this.repository);

  Future<void> call(Room room) async {
    await repository.addFeaturedRoom(room);
  }
}
