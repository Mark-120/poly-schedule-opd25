import "package:hive/hive.dart";

import '../../../domain/entities/group.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/entities/schedule/lesson.dart';
import '../../../domain/entities/teacher.dart';
import '../../models/schedule/lesson.dart';

class LessonAdapter extends TypeAdapter<Lesson> {
  @override
  final typeId = 40;
  @override
  Lesson read(BinaryReader reader) {
    var subject = reader.readString();
    var type = reader.readString();
    var typeAbbr = reader.readString();
    var start = reader.readString();
    var end = reader.readString();
    var groups = reader.readList().map((x) => x as Group).toList();
    var auditories = reader.readList().map((x) => x as Room).toList();
    var teachers = reader.readList().map((x) => x as Teacher).toList();
    var webinarUrl = reader.readString();
    var lmsUrl = reader.readString();

    return LessonModel(
      subject: subject,
      type: type,
      typeAbbr: typeAbbr,
      start: start,
      end: end,
      groups: groups,
      auditories: auditories,
      teachers: teachers,
      webinarUrl: webinarUrl,
      lmsUrl: lmsUrl,
    );
  }

  @override
  void write(BinaryWriter writer, Lesson obj) {
    writer.writeString(obj.subject);
    writer.writeString(obj.type);
    writer.writeString(obj.typeAbbr);
    writer.writeString(obj.start);
    writer.writeString(obj.end);
    writer.writeList(obj.groups);
    writer.writeList(obj.auditories);
    writer.writeList(obj.teachers);
    writer.writeString(obj.webinarUrl);
    writer.writeString(obj.lmsUrl);
  }
}
