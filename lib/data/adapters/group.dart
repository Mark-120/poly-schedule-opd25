import "package:hive/hive.dart";
import '../../domain/entities/group.dart';
import '../models/group.dart';

class GroupAdapter extends TypeAdapter<Group> {
  @override
  final typeId = 30;
  @override
  Group read(BinaryReader reader) {
    var id = reader.readInt();
    var name = reader.readString();
    return GroupModel(id: GroupId(id), name: name);
  }

  @override
  void write(BinaryWriter writer, Group obj) {
    writer.writeInt(obj.id.id);
    writer.writeString(obj.name);
  }
}
