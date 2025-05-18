import 'package:hive/hive.dart';

import '../models/last_schedule.dart';

class LastScheduleAdapter extends TypeAdapter<LastSchedule> {
  @override
  final int typeId = 70;

  @override
  LastSchedule read(BinaryReader reader) {
    return LastSchedule.fromMap(reader.read());
  }

  @override
  void write(BinaryWriter writer, LastSchedule obj) {
    writer.write(obj.toMap());
  }
}
