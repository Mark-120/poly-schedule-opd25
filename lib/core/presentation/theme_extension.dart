import 'package:flutter/material.dart';

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final Color primaryColor;
  final Color secondaryColor;
  final Color firstLayerCardBackgroundColor;
  final Color secondLayerCardBackgroundColor;
  final Color iconColor;

  CustomThemeExtension({
    required this.primaryColor,
    required this.secondaryColor,
    required this.firstLayerCardBackgroundColor,
    required this.secondLayerCardBackgroundColor,
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
