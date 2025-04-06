import 'package:equatable/equatable.dart';
import 'package:poly_scheduler/domain/entities/building.dart';

class Room extends Equatable {
  final int id;
  final String name;
  final Building building;

  const Room({required this.id, required this.name, required this.building});

  @override
  List<Object?> get props => [id, name];
}
