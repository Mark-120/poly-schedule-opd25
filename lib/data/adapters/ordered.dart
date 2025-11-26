import 'package:hive/hive.dart';
import '../models/ordered/ordered.dart';

class OrderedTeacherAdapter extends TypeAdapter<OrderedTeacher> {
  @override
  final typeId = 100;
  @override
  OrderedTeacher read(BinaryReader reader) {
    var value = reader.read();
    var id = reader.readInt();
    return OrderedTeacher(value, id);
  }

  @override
  void write(BinaryWriter writer, OrderedTeacher obj) {
    writer.write(obj.value);
    writer.writeInt(obj.order);
  }
}

class OrderedGroupAdapter extends TypeAdapter<OrderedGroup> {
  @override
  final typeId = 101;
  @override
  OrderedGroup read(BinaryReader reader) {
    var value = reader.read();
    var id = reader.readInt();
    return OrderedGroup(value, id);
  }

  @override
  void write(BinaryWriter writer, OrderedGroup obj) {
    writer.write(obj.value);
    writer.writeInt(obj.order);
  }
}

class OrderedRoomAdapter extends TypeAdapter<OrderedRoom> {
  @override
  final typeId = 102;
  @override
  OrderedRoom read(BinaryReader reader) {
    var value = reader.read();
    var id = reader.readInt();
    return OrderedRoom(value, id);
  }

  @override
  void write(BinaryWriter writer, OrderedRoom obj) {
    writer.write(obj.value);
    writer.writeInt(obj.order);
  }
}
