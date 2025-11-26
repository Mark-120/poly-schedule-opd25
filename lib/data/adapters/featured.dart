import 'package:hive/hive.dart';

import '../../domain/entities/featured.dart';

class FeaturedAdapter extends TypeAdapter<Featured> {
  @override
  final int typeId = 80;

  @override
  Featured read(BinaryReader reader) {
    final isFeatured = reader.readBool();
    final entity = reader.read();

    return Featured(entity, isFeatured: isFeatured);
  }

  @override
  void write(BinaryWriter writer, Featured obj) {
    writer.writeBool(obj.isFeatured);
    writer.write(obj.entity);
  }
}
