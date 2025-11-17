import 'entity.dart';

class Featured<T extends Entity> {
  final T entity;
  final bool isFeatured;

  Featured(this.entity, {this.isFeatured = false});
}
