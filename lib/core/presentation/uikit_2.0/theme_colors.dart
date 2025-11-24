import 'package:flutter/material.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {
  final Color textPrimary;
  final Color tile;
  final Color hint;
  final Color red;

  ThemeColors({
    required this.textPrimary,
    required this.hint,
    required this.tile,
    required this.red,
  });

  @override
  @override
  ThemeExtension<ThemeColors> copyWith({
    Color? textPrimary,
    Color? tile,
    Color? hint,
    Color? red,
  }) {
    return ThemeColors(
      textPrimary: textPrimary ?? this.textPrimary,
      tile: tile ?? this.tile,
      hint: hint ?? this.hint,
      red: red ?? this.red,
    );
  }

  @override
  ThemeExtension<ThemeColors> lerp(ThemeColors? other, double t) {
    return ThemeColors(
      textPrimary:
          Color.lerp(textPrimary, other?.textPrimary, t) ?? Colors.black,
      tile: Color.lerp(tile, other?.tile, t) ?? Colors.black,
      hint: Color.lerp(hint, other?.hint, t) ?? Colors.black,
      red: Color.lerp(red, other?.red, t) ?? Colors.black,
    );
  }
}
