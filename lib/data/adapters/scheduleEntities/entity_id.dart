import 'package:hive/hive.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/entities/teacher.dart';

class RoomIdAdapter extends TypeAdapter<RoomId> {
  @override
  final typeId = 3;
  @override
  RoomId read(BinaryReader reader) {
    var buildingId = reader.readInt();
    var id = reader.readInt();
    return RoomId(roomId: id, buildingId: buildingId);
  }

  @override
  void write(BinaryWriter writer, RoomId obj) {
    writer.writeInt(obj.buildingId);
    writer.writeInt(obj.roomId);
  }
}

class GroupIdAdapter extends TypeAdapter<GroupId> {
  @override
  final typeId = 4;
  @override
  GroupId read(BinaryReader reader) {
    var id = reader.readInt();
    return GroupId(id);
  }

  @override
  void write(BinaryWriter writer, GroupId obj) {
    writer.writeInt(obj.id);
  }
}

class TeacherIdAdapter extends TypeAdapter<TeacherId> {
  @override
  final typeId = 5;
  @override
  TeacherId read(BinaryReader reader) {
    var id = reader.readInt();
    return TeacherId(id);
  }

  @override
  void write(BinaryWriter writer, TeacherId obj) {
    writer.writeInt(obj.id);
  }
}
