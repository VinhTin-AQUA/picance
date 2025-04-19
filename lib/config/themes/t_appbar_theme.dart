import 'package:flutter/material.dart';

class TAppbarTheme {
  TAppbarTheme._();

  static final lightMode = AppBarTheme(
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
    ),
  );

  static final darkMode = AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
    ),
  );
}
