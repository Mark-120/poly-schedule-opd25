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
