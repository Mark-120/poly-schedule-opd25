import '../../../domain/entities/group.dart';
import '../../../domain/entities/room.dart';
import '../../../domain/entities/teacher.dart';
import '../../repository/featured_repository.dart';

class OrderedGroup extends OrderedEntity<Group> {
  OrderedGroup(super.value, super.order);
}

class OrderedRoom extends OrderedEntity<Room> {
  OrderedRoom(super.value, super.order);
}

class OrderedTeacher extends OrderedEntity<Teacher> {
  OrderedTeacher(super.value, super.order);
}
