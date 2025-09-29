import 'package:equatable/equatable.dart';

class GroupId extends Equatable {
  final int id;

  const GroupId(this.id);

  @override
  List<Object?> get props => [id];
  factory GroupId.parse(String string) {
    return GroupId(int.parse(string));
  }
  @override
  String toString() {
    return '$id';
  }
}

abstract class Group with EquatableMixin {
  final GroupId id;
  final String name;
  const Group({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
