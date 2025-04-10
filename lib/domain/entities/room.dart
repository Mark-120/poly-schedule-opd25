import 'package:equatable/equatable.dart';
import 'building.dart';

class Room extends Equatable {
  final int id;
  final String name;
  final Building building;

  const Room({required this.id, required this.building, required this.name});

  @override
  List<Object?> get props => [id, building, name];
}
