import 'package:flutter/material.dart';

class AppTextStyles {
  final TextStyle headerLarge;
  final TextStyle errorMessage;
  final TextStyle headerMedium;
  final TextStyle bodyMedium;
  final TextStyle lessonName;
  final TextStyle lessonInformation;
  final TextStyle teacher;

  AppTextStyles({
    required this.headerLarge,
    required this.headerMedium,
    required this.errorMessage,
    required this.bodyMedium,
    required this.lessonName,
    required this.lessonInformation,
    required this.teacher,
  });
  // final TextStyle caption;

  // Стандартные стили (можно сделать несколько вариантов)
  static AppTextStyles get defaultStyles => AppTextStyles(
    headerLarge: TextStyle(),
    headerMedium: headerMedium,
    errorMessage: errorMessage,
    bodyMedium: bodyMedium,
    lessonName: lessonName,
    lessonInformation: lessonInformation,
    teacher: teacher,
  );
  // Темные стили
  static AppTextStyles get darkStyles => AppTextStyles(
    displayLarge: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    // Остальные стили для темной темы...
  );
}
