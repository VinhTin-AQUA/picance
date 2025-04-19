import 'package:flutter/material.dart';

class TContainerTheme {
  TContainerTheme._();

  static List<BoxShadow> boxShadows(BuildContext context) => [
        BoxShadow(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          blurRadius: 1.5,
          offset: Offset(0, 1),
        ),
      ];

  static BoxDecoration boxDecoration(BuildContext context) => BoxDecoration(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900] // Màu cho dark mode
          : Colors.grey[100], // Màu cho light mode,
      borderRadius: BorderRadius.circular(8),
      boxShadow: TContainerTheme.boxShadows(context));
}
