import '../../../entities/room.dart';
import '../../../repositories/featured_repository.dart';
import '../../../repositories/schedule_repository.dart';

class SetFeaturedRooms {
  final ScheduleRepository scheduleRepository;
  final FeaturedRepository repository;

  SetFeaturedRooms(this.repository, this.scheduleRepository);

  Future<void> call(List<Room> rooms) async {
    await repository.setFeaturedRooms(rooms);
    await scheduleRepository.onFeaturedChanged();
  }
}
