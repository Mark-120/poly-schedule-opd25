import 'package:hive/hive.dart';
import '../../../domain/entities/schedule/day.dart';
import '../../../domain/entities/schedule/week.dart';
import '../../models/schedule/week.dart';

class WeekAdapter extends TypeAdapter<Week> {
  @override
  final typeId = 60;
  @override
  Week read(BinaryReader reader) {
    var isOdd = reader.readBool();
    var days = reader.readList().map((x) => x as Day).toList();
    var dateStart = reader.read();
    var dateEnd = reader.read();
    return WeekModel(
      isOdd: isOdd,
      days: days,
      dateStart: dateStart,
      dateEnd: dateEnd,
    );
  }

  @override
  void write(BinaryWriter writer, Week obj) {
    writer.writeBool(obj.isOdd);
    writer.writeList(obj.days);
    writer.write(obj.dateStart);
    writer.write(obj.dateEnd);
  }
}

class WeekDateAdapter extends TypeAdapter<(Week, DateTime)> {
  @override
  final typeId = 61;
  @override
  (Week, DateTime) read(BinaryReader reader) {
    var week = reader.read(); //Use of Weed id
    var date = reader.read(); //Use of Date id
    return (week, date);
  }

  @override
  void write(BinaryWriter writer, (Week, DateTime) obj) {
    writer.write(obj.$1);
    writer.write(obj.$2);
  }
}
