import "package:hive/hive.dart";
import '../../domain/entities/teacher.dart';
import '../models/teacher.dart';

class TeacherAdapter extends TypeAdapter<Teacher> {
  @override
  final typeId = 10;
  @override
  Teacher read(BinaryReader reader) {
    var id = reader.readInt();
    var name = reader.readString();
    return TeacherModel(id: TeacherId(id), fullName: name);
  }

  @override
  void write(BinaryWriter writer, Teacher obj) {
    writer.writeInt(obj.id.id);
    writer.writeString(obj.fullName);
  }
}
