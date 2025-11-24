import 'package:hive/hive.dart';

import '../../domain/entities/featured.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/room.dart';
import '../../domain/entities/teacher.dart';

class FeaturedAdapter extends TypeAdapter<Featured> {
  @override
  final int typeId = 80;

  @override
  Featured read(BinaryReader reader) {
    final type = reader.readInt();
    final isFeatured = reader.readBool();

    switch (type) {
      case 1:
        final teacher = reader.read() as Teacher;
        return Featured<Teacher>(teacher, isFeatured: isFeatured);
      case 2:
        final room = reader.read() as Room;
        return Featured<Room>(room, isFeatured: isFeatured);
      case 3:
        final group = reader.read() as Group;
        return Featured<Group>(group, isFeatured: isFeatured);
      default:
        throw Exception('Unknown Featured type: $type');
    }
  }

  @override
  void write(BinaryWriter writer, Featured obj) {
    if (obj.entity is Teacher) {
      writer.writeInt(1);
      writer.writeBool(obj.isFeatured);
      writer.write(obj.entity);
    } else if (obj.entity is Room) {
      writer.writeInt(2);
      writer.writeBool(obj.isFeatured);
      writer.write(obj.entity);
    } else if (obj.entity is Group) {
      writer.writeInt(3);
      writer.writeBool(obj.isFeatured);
      writer.write(obj.entity);
    } else {
      throw Exception('Unsupported entity type inside Featured');
    }
  }
}
