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
      extensions: <ThemeExtension<dynamic>>[
        CustomThemeExtension(
          primaryColor: AppColors.secondaryColor,
          daySectionBackgroundColor: AppColors.lightGreenColor,
          iconColor: AppColors.white,
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return AppTheme.lightTheme.copyWith(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundDarkColor,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
        color: AppColors.darkGrayGreenColor,
        margin: const EdgeInsets.only(bottom: 12),
      ),
      extensions: <ThemeExtension<dynamic>>[
        CustomThemeExtension(
          primaryColor: AppColors.lightGreenColor,
          daySectionBackgroundColor: AppColors.secondaryColor,
          iconColor: AppColors.white,
        ),
      ],
    );
  }
}

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color primaryColor;
  final Color daySectionBackgroundColor;
  final Color iconColor;

  CustomThemeExtension({
    required this.primaryColor,
    required this.daySectionBackgroundColor,
    required this.iconColor,
  });

  @override
  ThemeExtension<CustomThemeExtension> copyWith() => this;

  @override
  ThemeExtension<CustomThemeExtension> lerp(
    ThemeExtension<CustomThemeExtension>? other,
    double t,
  ) {
    return this;
  }
}

extension ThemeContext on BuildContext {
  CustomThemeExtension get appTheme =>
      Theme.of(this).extension<CustomThemeExtension>()!;
}
