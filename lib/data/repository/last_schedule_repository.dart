import 'package:hive/hive.dart';

import '../../core/logger.dart';
import '../../domain/repositories/last_schedule_repository.dart';
import '../models/last_schedule.dart';

class LastScheduleRepositoryImpl implements LastScheduleRepository {
  final Box<LastSchedule> box;
  final AppLogger logger;

  LastScheduleRepositoryImpl(this.box, {required this.logger});

  @override
  Future<LastSchedule?> getLastSchedule() async {
    logger.debug('[Cache] LastSchedule - GET');
    return box.get('last_schedule');
  }

  @override
  Future<void> saveLastSchedule(LastSchedule schedule) async {
    logger.debug('[Cache] LastSchedule - SET $schedule');
    await box.put('last_schedule', schedule);
  }
}
