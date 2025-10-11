import '../../../entities/room.dart';
import '../../../repositories/featured_repository.dart';
import '../../../repositories/schedule_repository.dart';

class AddFeaturedRoom {
  final ScheduleRepository scheduleRepository;
  final FeaturedRepository repository;

  AddFeaturedRoom(this.repository, this.scheduleRepository);

  Future<void> call(Room room) async {
    await repository.addFeaturedRoom(room);
    await scheduleRepository.onFeaturedChanged();
  }
}
