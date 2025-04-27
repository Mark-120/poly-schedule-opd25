import 'package:equatable/equatable.dart';

class Building with EquatableMixin {
  final int id;
  final String name;
  final String abbr;
  final String address;
  const Building({
    required this.id,
    required this.name,
    required this.abbr,
    required this.address,
  });
  @override
  List<Object?> get props => [id, name, abbr, address];
}
