import 'package:equatable/equatable.dart';
import 'building.dart';
import 'entity.dart';
import 'entity_id.dart';

class RoomId extends EntityId with EquatableMixin {
  final int roomId;
  final int buildingId;

  const RoomId({required this.roomId, required this.buildingId});

  @override
  List<Object?> get props => [roomId, buildingId];

  factory RoomId.parse(String string) {
    final splitted = string.split('_');
    return RoomId(
      roomId: int.parse(splitted[0]),
      buildingId: int.parse(splitted[1]),
    );
  }
  @override
  String toString() {
    return '${roomId}_$buildingId';
  }

  @override
  String toUniqueString() {
    return 'r${toString()}';
  }
}

abstract class Room extends ScheduleEntity with EquatableMixin {
  final int id;
  final String name;
  final Building building;

  const Room({required this.id, required this.building, required this.name});

  @override
  RoomId getId() {
    return RoomId(roomId: id, buildingId: building.id);
  }

  @override
  List<Object?> get props => [id, name, building];
}
