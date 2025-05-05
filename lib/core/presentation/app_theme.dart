import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF4FA24E);
  static const Color secondaryColor = Color(0xFF244029);
  static const Color darkGrayGreenColor = Color(0xFF5F7863);
  static const Color lightGrayGreenColor = Color(0xFFACC3AC);
  static const Color lightGreenColor = Color(0xFFCFE3CF);
  static const Color backgroundDarkColor = Color(0xFF121212);
  static const Color darkGrayColor = Color(0xFF212121);
  static const Color s = Colors.white;
  static const Color backgroundLightColor = Color(0xFFF5F5F5);
  static const Color editGray = Color(0xFF5F5F5F);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundLightColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: TextTheme(
        // Используется для заголовков
        headlineLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 30,
          color: secondaryColor,
        ),
        // Используется для заголовка ошибки
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        //Используется для подзаголовков (дни недели в AppBar на странице "ScheduleScreen")
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        //Отдельный стиль для надписи "Информация о парах отсутствует"
        displayMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Color(0xFF244029),
        ),
        //Отдельный стиль для дня недели в карточке "DaySection"
        labelLarge: TextStyle(color: Color(0xFF5F7863), fontSize: 20),
        // Отдельный стиль для
        labelSmall: TextStyle(color: Colors.white, fontSize: 14),
        // Стиль для надписей в карточке FeaturedCard
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF244029),
        ),
        bodyMedium: TextStyle(

        )
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
        color: cardColor,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        shape: CircleBorder(),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
