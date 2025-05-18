import 'package:hive/hive.dart';

import '../../domain/repositories/last_schedule_repository.dart';
import '../models/last_schedule.dart';

class LastScheduleRepositoryImpl implements LastScheduleRepository {
  final Box<LastSchedule> box;

  LastScheduleRepositoryImpl(this.box);

  @override
  Future<LastSchedule?> getLastSchedule() async {
    return box.get('last_schedule');
  }

  @override
  Future<void> saveLastSchedule(LastSchedule schedule) async {
    await box.put('last_schedule', schedule);
  }
}
