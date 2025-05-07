import 'package:flutter/material.dart';
import 'package:poly_scheduler/core/presentation/app_colors.dart';

extension ThemeExtension on ThemeData {
  Color get primaryColor =>
      brightness == Brightness.light
          ? AppColors.secondaryColor
          : AppColors.lightGreenColor;

  Color get daySectionBackgroundColor =>
      brightness == Brightness.light
          ? AppColors.lightGreenColor
          : AppColors.secondaryColor;
  
  Color get iconColor => AppColors.white;
}