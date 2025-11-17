import 'package:equatable/equatable.dart';

import 'entity.dart';

class TeacherId extends Equatable {
  final int id;

  const TeacherId(this.id);

  @override
  List<Object?> get props => [id];
  factory TeacherId.parse(String string) {
    return TeacherId(int.parse(string));
  }
  @override
  String toString() {
    return '$id';
  }
}

abstract class Teacher extends Entity with EquatableMixin {
  final TeacherId id;
  final String fullName;
  const Teacher({required this.id, required this.fullName});

  @override
  List<Object?> get props => [id, fullName];
}
