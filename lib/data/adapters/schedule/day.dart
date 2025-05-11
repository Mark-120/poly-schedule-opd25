import "package:hive/hive.dart";
import '../../../domain/entities/schedule/lesson.dart';
import '../../../domain/entities/schedule/day.dart';
import '../../models/schedule/day.dart';

class DayAdapter extends TypeAdapter<Day> {
  @override
  final typeId = 50;
  @override
  Day read(BinaryReader reader) {
    var date = reader.read();
    var lessons = reader.readList().map((x) => x as Lesson).toList();

    return DayModel(date: date, lessons: lessons);
  }

  @override
  void write(BinaryWriter writer, Day obj) {
    writer.write(obj.date);
    writer.writeList(obj.lessons);
  }
}
