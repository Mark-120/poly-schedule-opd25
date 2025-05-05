import 'package:flutter/material.dart';

class AppTextStyles {
  final Brightness brightness;

  AppTextStyles(this.brightness);

  // Цвета текста для разных тем
  Color get _textColorPrimary =>
      brightness == Brightness.light ? Colors.black : Colors.white;

  Color get _textColorSecondary =>
      brightness == Brightness.light ? Colors.grey[800]! : Colors.grey[300]!;

  Color get _textColorAccent =>
      brightness == Brightness.light ? Colors.blue[700]! : Colors.blue[200]!;

  // Используется для заголовков
  TextStyle get title =>
      TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color: titleColor);

  //SettingsScreen
  TextStyle get itemText => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: itemColor,
  );

  //ScheduleScreen
    TextStyle get titleAppbar =>
      TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);
  // Используется для заголовка ошибки
  TextStyle get errorTitle =>
      TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color: errorColor);

  // Используется для содержимого ошибки
  TextStyle get errorBody =>
      TextStyle(fontWeight: FontWeight.w400, fontSize: 18, color: errorColor);

  TextStyle get subtitleAppbar => TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold);

  //Используется для подзаголовков (дни недели в AppBar на странице "ScheduleScreen")




  TextStyle get noInfoMessage => TextStyle(
    color: noInfoMessageColor,
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );


  TextStyle get 

  //Отдельный стиль для надписи "Информация о парах отсутствует"
  TextStyle get displayMedium => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Color(0xFF244029),
  );
  //Отдельный стиль для дня недели в карточке "DaySection"
  TextStyle get labelLarge => TextStyle(color: Color(0xFF5F7863), fontSize: 20);
  // Отдельный стиль для
  TextStyle get labelSmall => TextStyle(color: Colors.white, fontSize: 14);
  // Стиль для надписей в карточке FeaturedCard
  TextStyle get bodyLarge => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFF244029),
  );
  TextStyle get bodyMedium => TextStyle();

  // Основные текстовые стили
  // Используется для содержимого сообщения об ошибке
  TextStyle get bodyError => TextStyle(
    color: bodyErrorColor,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
}

// Обёртка для предоставления стилей в дереве виджетов
class AppTextStylesProvider extends InheritedWidget {
  final AppTextStyles styles;

  const AppTextStylesProvider({
    Key? key,
    required this.styles,
    required Widget child,
  }) : super(key: key, child: child);

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
