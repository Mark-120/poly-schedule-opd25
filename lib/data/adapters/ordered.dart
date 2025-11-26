import 'package:hive/hive.dart';
import '../repository/featured_repository.dart';

class OrderedEntityAdapter extends TypeAdapter<OrderedEntity> {
  @override
  final typeId = 2;
  @override
  OrderedEntity read(BinaryReader reader) {
    var value = reader.read();
    var id = reader.readInt();
    return OrderedEntity(value, id);
  }

  @override
  void write(BinaryWriter writer, OrderedEntity obj) {
    writer.write(obj.value);
    writer.writeInt(obj.order);
  }
}
