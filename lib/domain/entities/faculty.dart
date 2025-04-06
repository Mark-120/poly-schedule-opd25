import 'package:equatable/equatable.dart';

class Faculty extends Equatable {
  final int id;
  final String fullName;
  final String abbr;
  const Faculty({required this.id, required this.fullName, required this.abbr});

  @override
  List<Object?> get props => [id, fullName];
}
