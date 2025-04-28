import 'package:equatable/equatable.dart';

import 'lesson.dart';

abstract class Day with EquatableMixin {
  final DateTime date;
  final List<Lesson> lessons;
  const Day({required this.date, required this.lessons});

  @override
  List<Object?> get props => [date, lessons];
}
