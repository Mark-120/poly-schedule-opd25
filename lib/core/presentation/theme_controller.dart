import 'package:flutter/material.dart';
import '../../domain/entities/theme_setting.dart';
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
    final isLightTheme = setting.isLightTheme;
    return ThemeData(
      canvasColor: Colors.transparent,
      primaryColor: primaryColor,
      brightness: isLightTheme ? Brightness.light : Brightness.dark,
      scaffoldBackgroundColor:
          isLightTheme ? NewAppColors.bgLight : NewAppColors.bgDark,
      appBarTheme: AppBarTheme(
        shadowColor: Colors.black,
        backgroundColor: primaryColor,
        elevation: 2,
        centerTitle: true,
        toolbarHeight: 70,
      ),
      cardTheme: CardTheme(
        color: isLightTheme ? NewAppColors.white : NewAppColors.superDarkGray,
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
        isLightTheme
            ? AppTypography(
              textPrimaryColor: NewAppColors.black,
              textSecondaryColor: NewAppColors.darkGray,
              hintColor: NewAppColors.gray,
              pickedColor: NewAppColors.white,
            )
            : AppTypography(
              textPrimaryColor: NewAppColors.white,
              textSecondaryColor: NewAppColors.gray,
              hintColor: NewAppColors.gray,
              pickedColor: NewAppColors.white,
            ),
        isLightTheme
            ? ThemeColors(
              textPrimary: NewAppColors.black,
              tile: NewAppColors.white,
              hint: NewAppColors.gray,
              red: NewAppColors.errorsWarnings,
            )
            : ThemeColors(
              textPrimary: NewAppColors.white,
              tile: NewAppColors.superDarkGray,
              hint: NewAppColors.gray,
              red: NewAppColors.errorsWarnings,
            ),
      ],
    );
  }
}
