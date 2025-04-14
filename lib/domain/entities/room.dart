import 'package:equatable/equatable.dart';
import 'building.dart';
class RoomId extends Equatable {
  final int roomId;
  final int buildingId;

  const RoomId({required this.roomId, required this.buildingId});

  @override
  List<Object?> get props => [roomId, buildingId];
}

class Room extends Equatable {
  final int id;
  final String name;
  final Building building;

  const Room({required this.id, required this.building, required this.name});

  RoomId getId() {
    return RoomId(roomId: id, buildingId: building.id);
  }
    
  @override
  List<Object?> get props => [id, building, name];
}
