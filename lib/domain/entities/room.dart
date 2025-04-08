import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final int id;
  final int buildingId;
  final String name;

  const Room({required this.id, required this.buildingId, required this.name});

  @override
  List<Object?> get props => [id, buildingId, name];
}
