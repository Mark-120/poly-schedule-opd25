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
}
