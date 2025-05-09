class AppStrings {
  //Schedule Screen
  static const String evenWeek = 'четная';
  static const String oddWeek = 'нечетная';
  static const String noLessonInfoMessage = 'Информация о парах отсутствует';

  //Settings Screen
  static const String settingsTitle = 'Настройки';
  static const String themeOption = 'Тема';
  static const String errorReportButton = 'Сообщить об ошибке';

  //Search Screen
  static const String groupSearchTitle = 'Поиск группы';
  static const String teacherSearchTitle = 'Поиск преподавателя';

  static const String searchGroupHint = 'Введите номер группы...';
  static const String searchTeacherHint = 'Введите ФИО преподавателя...';

  static const String searchCenterHint = 'Введите запрос для поиска';
  static String emptyResultCenterHint(String query) =>
      'По запросу "$query" ничего не найдено';

  //Building search screen and Class search screen
  static const String buildingSearchTitle = 'Поиск здания';
  static const String classSearchTitle = 'Поиск аудитории';

  static const String firstPage = '1/2';
  static const String secondPage = '2/2';

  // Featured Screen
  static const String editModeSubtitle = 'режим изменения';

  static const String groupsFeaturedPageTitle = 'Группы';
  static const String lecturersFeaturedPageTitle = 'Преподаватели';
  static const String classesFeaturedPageTitle = 'Аудитории';
}
