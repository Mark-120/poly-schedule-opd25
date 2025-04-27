import 'package:equatable/equatable.dart';

class Group with EquatableMixin {
  final int id;
  final String name;
  const Group({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
