import 'package:equatable/equatable.dart';
import 'package:poly_scheduler/domain/entities/day.dart';

class Week extends Equatable {
  final DateTime dateStart;
  final DateTime dateEnd;
  final bool isOdd;
  final List<Day> days;
  const Week({
    required this.dateStart,
    required this.dateEnd,
    required this.isOdd,
    required this.days,
  });

  @override
  List<Object?> get props => [dateStart, dateEnd, isOdd, days];
}
