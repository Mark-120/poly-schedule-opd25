import 'package:equatable/equatable.dart';

abstract class Teacher with EquatableMixin {
  final int id;
  final String fullName;
  const Teacher({required this.id, required this.fullName});

  @override
  List<Object?> get props => [id, fullName];
}
