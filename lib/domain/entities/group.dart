import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final int id;
  final int facultyId;
  final String name;
  const Group({required this.id, required this.facultyId, required this.name});

  @override
  List<Object?> get props => [id, facultyId, name];
}
