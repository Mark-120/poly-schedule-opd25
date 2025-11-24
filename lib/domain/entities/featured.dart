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
    if (entity is Group) return EntityId.group(entity.id);
    if (entity is Teacher) return EntityId.teacher(entity.id);
    if (entity is Room) return EntityId.room(entity.getId());
    throw UnimplementedError();
  }
}
