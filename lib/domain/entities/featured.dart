import 'entity.dart';
import 'entity_id.dart';
import 'group.dart';
import 'room.dart';
import 'teacher.dart';

class Featured<T extends Entity> {
  final T entity;
  final bool isFeatured;

  Featured(this.entity, {this.isFeatured = false});

  Featured<T> copyWith({T? entity, bool? isFeatured}) {
    return Featured<T>(
      entity ?? this.entity,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  EntityId getEntityId() {
    final entity = this.entity;
    if (entity is Group) return entity.getId();
    if (entity is Teacher) return entity.getId();
    if (entity is Room) return entity.getId();
    throw UnimplementedError();
  }
}
