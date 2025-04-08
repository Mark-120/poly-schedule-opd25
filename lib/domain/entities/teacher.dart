import 'package:equatable/equatable.dart';

class Teacher extends Equatable {
  final int id;
  final String fullName;
  const Teacher({required this.id, required this.fullName});

  @override
  List<Object?> get props => [id, fullName];
}
