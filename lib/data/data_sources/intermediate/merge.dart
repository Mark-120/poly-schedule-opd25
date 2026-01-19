import '../../../domain/entities/entity_id.dart';
import '../../../domain/entities/schedule/day.dart';
import '../../../domain/entities/schedule/week.dart';
import '../../models/schedule/day.dart';
import '../../models/schedule/lesson.dart';
import '../../models/schedule/week.dart';
import '../interface/schedule.dart';
import 'pass_through.dart';

final class MergeDataSource extends PassThroughSource {
  MergeDataSource({required super.prevDataSource});
  @override
  Future<Week> getSchedule(EntityId id, DateTime dayTime) async {
    //Prefetch data
    var schedule = await prevDataSource.getSchedule(id, dayTime);
    var week = WeekModel(
      dateEnd: schedule.dateEnd,
      dateStart: schedule.dateStart,
      isOdd: schedule.isOdd,
      days: schedule.days.map(mergeDay).toList(),
    );
    return week;
  }

  //Merging schedules in one day
  Day mergeDay(Day day) {
    // Use a Map to group lessons by a composite key of all comparable fields except auditories
    final Map<String, LessonModel> merged = {};

    for (final lesson in day.lessons) {
      final key = [
        lesson.subject,
        lesson.type,
        lesson.typeAbbr,
        lesson.start,
        lesson.end,
        lesson.groups.map((g) => g.id).join(','),
        lesson.teachers.map((t) => t.id).join(','),
        lesson.webinarUrl,
        lesson.lmsUrl,
      ].join('|');

      if (merged.containsKey(key)) {
        final existing = merged[key]!;
        merged[key] = existing.copyWith(
          auditories: {...existing.auditories, ...lesson.auditories}.toList(),
        );
      } else {
        merged[key] = LessonModel.fromLesson(lesson);
      }
    }

    return DayModel(date: day.date, lessons: merged.values.toList());
  }
}
