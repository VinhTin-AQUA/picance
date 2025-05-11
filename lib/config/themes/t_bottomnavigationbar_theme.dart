import 'package:flutter/material.dart';

class TBottomnavigationbarTheme {
  TBottomnavigationbarTheme._();

  static final lightMode = BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xFFE11D48), // màu item khi chọn
    unselectedItemColor: Color(0xFFE11D48), // màu item khi không chọn
    selectedIconTheme: IconThemeData(size: 30),
    unselectedIconTheme: IconThemeData(size: 24),
    showUnselectedLabels: true, // hiện label cho item chưa chọn
  );

  static final darkMode = BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Color(0xFFE11D48), // màu item khi chọn
    unselectedItemColor: Color(0xFFE11D48), // màu item khi không chọn
    selectedIconTheme: IconThemeData(size: 30),
    unselectedIconTheme: IconThemeData(size: 24),
    showUnselectedLabels: true, // hiện label cho item chưa chọn
  );
}
