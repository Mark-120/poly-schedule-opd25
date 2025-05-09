import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  final BuildContext context;

  AppTextStyles(this.context);

  Brightness get _brightness => Theme.of(context).brightness;

  // Цвета текста для разных тем
  Color get _primaryColor =>
      _brightness == Brightness.light
          ? AppColors.secondaryColor
          : AppColors.lightGreenColor;

  Color get _errorColor =>
      _brightness == Brightness.light
          ? AppColors.lightGreenColor
          : AppColors.secondaryColor;

  Color get _secondaryColor =>
      _brightness == Brightness.light
          ? AppColors.darkGrayGreenColor
          : AppColors.lightGrayGreenColor;

  Color get _lessonTypeColor =>
      _brightness == Brightness.light
          ? AppColors.editGray
          : AppColors.lightGrayGreenColor;

  // Используется для заголовков
  TextStyle get title => TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 30,
    color: _primaryColor,
  );

  //SettingsScreen
  TextStyle get itemText => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: _primaryColor,
  );

  //ScheduleScreen
  TextStyle get titleAppbar => TextStyle(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  TextStyle get subtitleAppbar => TextStyle(
    color: AppColors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  TextStyle get errorTitle =>
      TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color: _errorColor);

  TextStyle get errorBody =>
      TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: _errorColor);

  TextStyle get noInfoMessage => TextStyle(
    color: _primaryColor,
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  TextStyle get titleBottomAppBar => TextStyle(
    color: AppColors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );

  //Стили для карточки "DaySection"
  TextStyle get subtitleDaySection => TextStyle(
    color: _secondaryColor,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  TextStyle get mainInfoClassCard => TextStyle(
    color: _primaryColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1,
  );

  TextStyle get teacherInfoClassCard =>
      TextStyle(color: _secondaryColor, fontSize: 12, height: 1);

  TextStyle get typeOfLessonClassCard => TextStyle(
    color: _lessonTypeColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  TextStyle get noLessonsMessage => TextStyle(
    color: _primaryColor,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  //Стили для экранов добавления Избранного
  TextStyle get subtitleChangeMode => const TextStyle(
    fontSize: 16,
    color: AppColors.editGray,
    fontWeight: FontWeight.w400,
  );
}

//Обёртка для предоставления стилей в дереве виджетов
class AppTextStylesProvider extends InheritedWidget {
  final AppTextStyles styles;

  const AppTextStylesProvider({
    super.key,
    required this.styles,
    required super.child,
  });

  static AppTextStyles of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<AppTextStylesProvider>();
    assert(result != null, 'No AppTextStylesProvider found in context');
    return result!.styles;
  }

  @override
  bool updateShouldNotify(AppTextStylesProvider oldWidget) =>
      oldWidget.styles != styles;
}
