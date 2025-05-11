import 'package:flutter/material.dart';
import 'package:picance/config/themes/t_appbar_theme.dart';
import 'package:picance/config/themes/t_bottomnavigationbar_theme.dart';
import 'package:picance/config/themes/t_elevated_button_theme.dart';
import 'package:picance/config/themes/t_icon_theme.dart';
import 'package:picance/config/themes/t_text_theme.dart';

import 't_checkbox_theme.dart';

class TAppTheme {
  TAppTheme._();

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Popins',
    brightness: Brightness.light,
    primaryColor: Colors.indigo,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonThemeData,
    checkboxTheme: TCheckboxTheme.lightTheme,
    appBarTheme: TAppbarTheme.lightMode,
    iconTheme: TIconTheme.lightMode,
    bottomNavigationBarTheme: TBottomnavigationbarTheme.lightMode,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Popins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: TTextTheme.darkTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonThemeData,
    checkboxTheme: TCheckboxTheme.darkTheme,
    appBarTheme: TAppbarTheme.darkMode,
    iconTheme: TIconTheme.darkMode,
    bottomNavigationBarTheme: TBottomnavigationbarTheme.darkMode,
  );
}
