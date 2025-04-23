import '../../domain/entities/room.dart';
import 'building.dart';

class RoomModel extends Room {
  const RoomModel({
    required super.id,
    required super.name,
    required super.building,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      name: json['name'],
      building: BuildingModel.fromJson(json['building']),
    );
  }
  factory RoomModel.fromJsonAndBuilding(
    Map<String, dynamic> json,
    BuildingModel building,
  ) {
    return RoomModel(id: json['id'], name: json['name'], building: building);
  }
}
