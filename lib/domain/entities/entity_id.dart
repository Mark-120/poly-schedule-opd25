import '../../core/exception/local_exception.dart';
import 'group.dart';
import 'room.dart';
import 'teacher.dart';

abstract class EntityId {
  const EntityId();

  String toUniqueString();

  factory EntityId.parseUnique(String string) {
    var subString = string.substring(1);
    switch (string[0]) {
      case 'g':
        return GroupId(int.parse(subString));
      case 'r':
        return RoomId.parse(subString);
      case 't':
        return TeacherId(int.parse(subString));
      default:
        throw LocalException('Incorrect format of EntityId');
    }
  }
}
