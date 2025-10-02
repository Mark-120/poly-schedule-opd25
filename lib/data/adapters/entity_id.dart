import 'package:hive/hive.dart';
import '../../domain/entities/entity_id.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/teacher.dart';

class EntityIdAdapter extends TypeAdapter<EntityId> {
  @override
  final typeId = 1;
  @override
  EntityId read(BinaryReader reader) {
    var type = reader.readInt();
    var id = reader.readInt();
    return switch (type) {
      1 => EntityId.teacher(TeacherId(id)),
      2 => EntityId.room(RoomId(roomId: id, buildingId: reader.readInt())),
      3 => EntityId.group(GroupId(id)),
      _ => throw Exception(),
    };
  }

  @override
  void write(BinaryWriter writer, EntityId obj) {
    if (obj.isTeacher) {
      writer.writeInt(1);
      writer.writeInt(obj.asTeacher.id);
    } else if (obj.isRoom) {
      writer.writeInt(2);
      writer.writeInt(obj.asRoom.roomId);
      writer.writeInt(obj.asRoom.buildingId);
    } else if (obj.isGroup) {
      writer.writeInt(3);
      writer.writeInt(obj.asGroup.id);
    }
  }
}
