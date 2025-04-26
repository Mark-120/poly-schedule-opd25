import 'day.dart';

class Week {
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
}
