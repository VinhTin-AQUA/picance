import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showNotificationDialog({
  required bool success,
  required String title,
  required String message,
}) async {
  Color backgroundColor;
  Color textColor;
  IconData icon;

  switch (success) {
    case true:
      backgroundColor = const Color.fromARGB(255, 183, 255, 185);
      textColor = const Color.fromARGB(255, 0, 168, 6);
      icon = Icons.check_circle;
      break;
    case false:
      backgroundColor = Colors.red.shade100;
      textColor = Colors.red;
      icon = Icons.error;
      break;
  }

  return Get.dialog(
    AlertDialog(
      backgroundColor: backgroundColor,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: Get.theme.textTheme.headlineSmall!.copyWith(
                color: textColor,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: Get.theme.textTheme.bodyMedium!.copyWith(color: textColor),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Close',
            style: Get.theme.textTheme.bodySmall!.copyWith(color: Colors.black),
          ),
          onPressed: () {
            Get.back(); // Sử dụng Get.back() thay vì Navigator.of(context).pop()
          },
        ),
      ],
    ),
    transitionDuration: Duration(milliseconds: 100),
  );
}
