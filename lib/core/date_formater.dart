import 'package:intl/intl.dart';

class DateFormater {
  static DateTime truncDate(DateTime input) {
    var truncHour = input.subtract(
      (Duration(
        hours: input.hour,
        minutes: input.minute,
        seconds: input.second,
        milliseconds: input.millisecond,
        microseconds: input.microsecond,
      )),
    );
    var truncDay = truncHour.subtract(Duration(days: truncHour.weekday - 1));
    return truncDay;
  }

  static String getStringFromDayTime(DateTime dayTime) {
    return '${dayTime.year}-${dayTime.month}-${dayTime.day}';
  }

  static String showShortDateToUser(DateTime dateTime) {
    return DateFormat('dd.MM', 'ru').format(dateTime);
  }

  static String showDateToUser(DateTime dateTime) {
    return DateFormat('d MMMM', 'ru').format(dateTime);
  }

  static String showWeekdayToUser(DateTime dateTime) {
    final weekday = DateFormat('EEEE', 'ru').format(dateTime);
    return weekday[0].toUpperCase() + weekday.substring(1);
  }

  static String showShortWeekdayToUser(DateTime dateTime) {
    final weekday = DateFormat('E', 'ru').format(dateTime);
    return weekday[0].toUpperCase() + weekday.substring(1);
  }
}

extension WeekNumber on DateTime {
  int get weekNumber {
    final firstDayOfYear = DateFormater.truncDate(DateTime(year, 1, 1));
    final differenceInDays = difference(firstDayOfYear).inDays;
    final weekNumber = (differenceInDays / 7).floor() + 1;
    return weekNumber;
  }

  bool get isOdd => (weekNumber % 2) == 1;
}
