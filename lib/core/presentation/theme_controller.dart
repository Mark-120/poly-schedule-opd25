import 'package:flutter/material.dart';
import '../../domain/entities/theme_setting.dart';
import 'uikit/app_colors.dart';
import 'uikit/theme_extension.dart';
import 'uikit_2.0/app_colors.dart';
import 'uikit_2.0/app_text_styles.dart';
import 'uikit_2.0/theme_colors.dart';

class AppThemeController extends ChangeNotifier {
  ThemeData _currentTheme;

  AppThemeController(ThemeSetting initialSetting)
    : _currentTheme = _createTheme(initialSetting);

  ThemeData get currentTheme => _currentTheme;

  void updateTheme(ThemeSetting setting) {
    _currentTheme = _createTheme(setting);
    notifyListeners();
  }

  static ThemeData _createTheme(ThemeSetting setting) {
    final primaryColor = setting.color;
    return ThemeData(
      canvasColor: Colors.transparent,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: NewAppColors.bgLight,
      appBarTheme: AppBarTheme(
        shadowColor: Colors.black,
        backgroundColor: primaryColor,
        elevation: 2,
        centerTitle: true,
        toolbarHeight: 70,
      ),
      cardTheme: CardTheme(
        color: NewAppColors.white,
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
        ThemeColors(
          textPrimary: NewAppColors.black,
          tile: NewAppColors.white,
          hint: NewAppColors.gray,
          red: NewAppColors.errorsWarnings,
        ),
      ],
    );
  }
}
