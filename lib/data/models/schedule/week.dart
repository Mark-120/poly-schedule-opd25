import '../../../domain/entities/schedule/day.dart';
import '../../../domain/entities/schedule/week.dart';
import 'day.dart';

class WeekModel extends Week {
  const WeekModel({
    required super.dateStart,
    required super.dateEnd,
    required super.days,
    required super.isOdd,
  });

  factory WeekModel.fromJson(Map<String, dynamic> json) {
    return WeekModel(
      dateStart: DateTime.parse(
        (json['week']['date_start'] as String).replaceAll('.', '-'),
      ),
      dateEnd: DateTime.parse(
        (json['week']['date_end'] as String).replaceAll('.', '-'),
      ),
      days: json['days'].map<Day>((day) => DayModel.fromJson(day)).toList(),
      isOdd: json['week']['is_odd'] as bool,
    );
  }
}
