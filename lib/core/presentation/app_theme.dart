import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundLightColor,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
        color: AppColors.lightGrayGreenColor,
        margin: const EdgeInsets.only(bottom: 12),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
        shape: CircleBorder(),
        elevation: 0,
      ),
      bottomAppBarTheme: BottomAppBarTheme(color: AppColors.primaryColor),
    );
  }

  static ThemeData get darkTheme {
    return AppTheme.lightTheme.copyWith(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundDarkColor,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
        color: AppColors.secondaryColor,
        margin: const EdgeInsets.only(bottom: 12),
      ),
    );
  }
}

extension CustomTheme on ThemeData {
  Color get primaryColor =>
      brightness == Brightness.light
          ? AppColors.secondaryColor
          : AppColors.lightGreenColor;

  Color get daySectionBackgroundColor =>
      brightness == Brightness.light
          ? AppColors.lightGreenColor
          : AppColors.secondaryColor;
}
