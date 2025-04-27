import 'package:equatable/equatable.dart';
import 'day.dart';

class Week with EquatableMixin {
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
