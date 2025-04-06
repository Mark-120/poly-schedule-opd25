import 'package:equatable/equatable.dart';
import 'package:poly_scheduler/domain/entities/schedule/lesson.dart';

class Day extends Equatable {
  final int weekday;
  final DateTime date;
  final List<Lesson> lessons;
  const Day({required this.weekday, required this.date, required this.lessons});

  @override
  List<Object?> get props => [weekday, date, lessons];
}
