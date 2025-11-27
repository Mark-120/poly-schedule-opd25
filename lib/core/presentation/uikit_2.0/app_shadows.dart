import 'package:flutter/material.dart';

class AppShadows {
  static final menuShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.25),
    blurRadius: 10,
    offset: Offset(0, -6),
    spreadRadius: 1,
  );

  static final footerShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.25),
    blurRadius: 10,
    offset: Offset(0, -4),
    spreadRadius: 1,
  );

  static final tileShadow = BoxShadow(
    color: Colors.black.withValues(alpha: 0.1),
    blurRadius: 1,
    offset: Offset(0, 0),
    spreadRadius: 1,
  );
}
