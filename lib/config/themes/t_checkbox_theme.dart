import 'package:flutter/material.dart';

class TCheckboxTheme {
  TCheckboxTheme._();

  static final CheckboxThemeData lightTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Color(0xffe11d48);
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.resolveWith((states) => Colors.white),
  );

  static final CheckboxThemeData darkTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Color(0xffe11d48);
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.resolveWith((states) => Colors.white),
  );
}
