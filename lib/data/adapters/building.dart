import "package:hive/hive.dart";
import '../../domain/entities/building.dart';
import '../models/building.dart';

class BuildingAdapter extends TypeAdapter<Building> {
  @override
  final typeId = 22;
  @override
  Building read(BinaryReader reader) {
    var id = reader.readInt();
    var name = reader.readString();
    var abbr = reader.readString();
    var address = reader.readString();
    return BuildingModel(id: id, name: name, abbr: abbr, address: address);
  }

  @override
  void write(BinaryWriter writer, Building obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.abbr);
    writer.writeString(obj.address);
  }
}
