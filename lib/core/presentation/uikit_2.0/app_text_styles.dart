import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles extends ThemeExtension<AppTextStyles> {
  final Color? _textPrimaryColor;
  final Color? _textSecondaryColor;
  final Color? _hintColor;
  final Color? _pickedColor;

  AppTextStyles({
    required Color? textPrimaryColor,
    required Color? textSecondaryColor,
    required Color? hintColor,
    required Color? pickedColor,
  }) : _textPrimaryColor = textPrimaryColor,
       _textSecondaryColor = textSecondaryColor,
       _pickedColor = pickedColor,
       _hintColor = hintColor;

  //// THEMES FOR PAGES

  // SchedulePage

  TextStyle get appBarTitle => TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
  TextStyle get appBarSubtitle =>
      TextStyle(fontSize: 14, color: AppColors.white);

  TextStyle get dayTitle => TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: _textPrimaryColor,
  );
  TextStyle get timeBody => TextStyle(fontSize: 14, color: _textPrimaryColor);
  TextStyle get subjectTitle =>
      TextStyle(fontSize: 15, color: _textPrimaryColor);
  TextStyle get subjectSubtitle =>
      TextStyle(fontSize: 13, color: _textSecondaryColor);

  TextStyle get bottomBarTitle =>
      TextStyle(fontSize: 16, color: _textPrimaryColor);

  TextStyle get emptySchedule =>
      TextStyle(fontSize: 22, color: _textPrimaryColor);

  // Methods to override ThemeExtension

  @override
  ThemeExtension<AppTextStyles> copyWith({
    Color? textPrimaryColor,
    Color? textSecondaryColor,
    Color? hintColor,
  }) {
    return AppTextStyles(
      textPrimaryColor: textPrimaryColor ?? _textPrimaryColor,
      textSecondaryColor: textSecondaryColor ?? _textSecondaryColor,
      hintColor: hintColor ?? _hintColor,
      pickedColor: _pickedColor ?? _pickedColor,
    );
  }

  @override
  ThemeExtension<AppTextStyles> lerp(AppTextStyles? other, double t) {
    return AppTextStyles(
      textPrimaryColor: Color.lerp(
        _textPrimaryColor,
        other?._textPrimaryColor,
        t,
      ),
      textSecondaryColor: Color.lerp(
        _textSecondaryColor,
        other?._textSecondaryColor,
        t,
      ),
      hintColor: Color.lerp(_hintColor, other?._hintColor, t),
      pickedColor: Color.lerp(_pickedColor, other?._pickedColor, t),
    );
  }
}
