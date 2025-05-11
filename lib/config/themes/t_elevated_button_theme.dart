import 'package:flutter/material.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static final ElevatedButtonThemeData lightElevatedButtonThemeData =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          disabledForegroundColor: Colors.grey,
          disabledBackgroundColor: Colors.grey,
          side: BorderSide(color: Color(0xffe11d48), ),
          backgroundColor: Color(0xffe11d48), // Màu nền
          foregroundColor: Colors.white, // Màu chữ/icon
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 3, // Độ nổi (bóng đổ)
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          iconColor: Colors.white,
          iconSize: 20,
        ),
      );

  static final ElevatedButtonThemeData darkElevatedButtonThemeData =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          disabledForegroundColor: Colors.grey,
          disabledBackgroundColor: Colors.grey,
          side: BorderSide(color: Color(0xffe11d48)),
          backgroundColor: Color(0xffe11d48), // Màu nền
          foregroundColor: Colors.white, // Màu chữ/icon
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 3, // Độ nổi (bóng đổ)
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          iconColor: Colors.white,
          iconSize: 20,
        ),
      );

  static pressButton(pressColor, idleColor) =>
      WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return pressColor;
        }
        return idleColor; // default color
      });
}
