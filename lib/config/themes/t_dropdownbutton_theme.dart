import 'package:flutter/material.dart';

class TDropdownButtonTheme {
  TDropdownButtonTheme._();

  static Color dropdownColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white;
}
