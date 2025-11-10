import 'package:flutter/material.dart';

import '../uikit/app_colors.dart';
import '../uikit/theme_extension.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  final Color primaryColor;

  AppTheme(this.primaryColor);

  ThemeData get lightTheme {
    return ThemeData(
      canvasColor: Colors.transparent,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: NewAppColors.bgLight,
      appBarTheme: AppBarTheme(
        shadowColor: Colors.black,
        backgroundColor: primaryColor,
        elevation: 2,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        shape: CircleBorder(),
        elevation: 0,
      ),
      bottomAppBarTheme: BottomAppBarTheme(color: primaryColor),
      extensions: <ThemeExtension<dynamic>>[
        CustomThemeExtension(
          primaryColor: AppColors.primaryColor,
          secondaryColor: AppColors.secondaryColor,
          firstLayerCardBackgroundColor: AppColors.lightGreenColor,
          secondLayerCardBackgroundColor: AppColors.lightGrayGreenColor,
          iconColor: AppColors.white,
          searchFieldBackgroundColor: AppColors.white,
        ),
        AppTypography(
          textPrimaryColor: NewAppColors.black,
          textSecondaryColor: NewAppColors.darkGray,
          hintColor: NewAppColors.gray,
          pickedColor: NewAppColors.white,
        ),
      ],
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      canvasColor: Colors.transparent,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: NewAppColors.bgDark,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        shape: CircleBorder(),
        elevation: 0,
      ),
      bottomAppBarTheme: BottomAppBarTheme(color: primaryColor),
      extensions: <ThemeExtension<dynamic>>[
        AppTypography(
          textPrimaryColor: NewAppColors.white,
          textSecondaryColor: NewAppColors.gray,
          hintColor: NewAppColors.gray,
          pickedColor: NewAppColors.white,
        ),
      ],
    );
  }
}
