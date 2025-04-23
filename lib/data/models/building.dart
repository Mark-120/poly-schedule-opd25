import '../../domain/entities/building.dart';

class BuildingModel extends Building {
    const BuildingModel({
        required super.id,
        required super.name,
        required super.address,
    });
    
    factory BuildingModel.fromJson(Map<String, dynamic> json) {
        return BuildingModel(
        id: json['id'],
        name: json['name'],
        address: json['address'],
        );
    }
} 