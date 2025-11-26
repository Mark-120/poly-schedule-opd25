import '../../core/exception/local_exception.dart';
import 'group.dart';
import 'room.dart';
import 'teacher.dart';

abstract class EntityId {
  const EntityId();

  String toUniqueString();

  factory EntityId.parseUnique(String string) {
    var strings = string.split(',');
    switch (strings[1]) {
      case 'g':
        return GroupId(int.parse(strings[0]));
      case 'r':
        return RoomId.parse(strings[0]);
      case 't':
        return TeacherId(int.parse(strings[0]));
      default:
        throw LocalException('Incorrect format of EntityId');
    }
  }
}
