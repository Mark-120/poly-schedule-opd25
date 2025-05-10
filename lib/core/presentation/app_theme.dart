import 'package:flutter/material.dart';

import 'theme_extension.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      canvasColor: Colors.transparent,
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
        margin: const EdgeInsets.only(bottom: 12),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
        shape: CircleBorder(),
        elevation: 0,
      ),
      bottomAppBarTheme: BottomAppBarTheme(color: AppColors.primaryColor),
      extensions: <ThemeExtension<dynamic>>[
        CustomThemeExtension(
          primaryColor: AppColors.primaryColor,
          secondaryColor: AppColors.secondaryColor,
          firstLayerCardBackgroundColor: AppColors.lightGreenColor,
          secondLayerCardBackgroundColor: AppColors.lightGrayGreenColor,
          iconColor: AppColors.white,
          searchFieldBackgroundColor: AppColors.white,
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return AppTheme.lightTheme.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDarkColor,
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
      ),
      extensions: <ThemeExtension<dynamic>>[
        CustomThemeExtension(
          primaryColor: AppColors.primaryColor,
          secondaryColor: AppColors.lightGreenColor,
          firstLayerCardBackgroundColor: AppColors.secondaryColor,
          secondLayerCardBackgroundColor: AppColors.darkGrayGreenColor,
          iconColor: AppColors.white,
          searchFieldBackgroundColor: AppColors.darkGrayColor,
        ),
      ],
    );
  }
}
