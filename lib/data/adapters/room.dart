import 'package:hive/hive.dart';
import '../../domain/entities/room.dart';
import '../models/room.dart';

class RoomAdapter extends TypeAdapter<Room> {
  @override
  final typeId = 20;
  @override
  Room read(BinaryReader reader) {
    var id = reader.readInt();
    var name = reader.readString();
    var building = reader.read();
    return RoomModel(id: id, name: name, building: building);
  }

  @override
  void write(BinaryWriter writer, Room obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.write(obj.building);
  }
}

class RoomIdAdapter extends TypeAdapter<RoomId> {
  @override
  final typeId = 21;
  @override
  RoomId read(BinaryReader reader) {
    var roomId = reader.readInt();
    var buildingId = reader.readInt();
    return RoomId(roomId: roomId, buildingId: buildingId);
  }

  @override
  void write(BinaryWriter writer, RoomId obj) {
    writer.writeInt(obj.roomId);
    writer.writeInt(obj.buildingId);
  }
}
