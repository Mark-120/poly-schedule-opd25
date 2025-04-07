import 'package:equatable/equatable.dart';

import 'day.dart';

class Week extends Equatable {
  final DateTime dateStart;
  //dateEnd can be restored by adding 6 days to dateStart
  final bool isOdd;
  final List<Day> days;
  const Week({
    required this.dateStart,
    required this.isOdd,
    required this.days,
  });

  @override
  List<Object?> get props => [dateStart, isOdd, days];
}
