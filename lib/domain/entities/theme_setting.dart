import 'dart:ui';

import 'package:equatable/equatable.dart';

class ThemeSetting with EquatableMixin {
  final Color color;
  final bool isLightTheme;
  const ThemeSetting({required this.color, required this.isLightTheme});
  @override
  List<Object?> get props => [color, isLightTheme];
}
