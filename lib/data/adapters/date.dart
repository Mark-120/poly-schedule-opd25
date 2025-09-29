import 'package:hive/hive.dart';

class DateAdapter extends TypeAdapter<DateTime> {
  @override
  final typeId = 0;
  @override
  DateTime read(BinaryReader reader) {
    return DateTime.fromMicrosecondsSinceEpoch(reader.readInt(), isUtc: true);
  }

  @override
  void write(BinaryWriter writer, DateTime obj) {
    writer.writeInt(obj.toUtc().microsecondsSinceEpoch);
  }
}
