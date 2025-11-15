import 'package:flutter/material.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {
  final Color textPrimary;
  final Color tile;

  ThemeColors({required this.textPrimary, required this.tile});

  @override
  @override
  ThemeExtension<ThemeColors> copyWith({Color? textPrimary, Color? tile}) {
    return ThemeColors(
      textPrimary: textPrimary ?? this.textPrimary,
      tile: tile ?? this.tile,
    );
  }

  @override
  ThemeExtension<ThemeColors> lerp(ThemeColors? other, double t) {
    return ThemeColors(
      textPrimary:
          Color.lerp(textPrimary, other?.textPrimary, t) ?? Colors.black,
      tile: Color.lerp(tile, other?.tile, t) ?? Colors.black,
    );
  }
}
