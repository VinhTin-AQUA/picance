import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> questionDialog({
  required String message,
  required Future<void> Function() onPressed,
}) async {
  return Get.dialog(
    AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Icon(Icons.help_outlined), Text(message)],
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.indigo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.indigo, strokeAlign: 2),
            ),
            shadowColor: Colors.transparent,
            elevation: 0,
          ),
          child: Text('no'.tr),
          onPressed: () {
            Get.back();
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.indigo, strokeAlign: 0),
            ),
            shadowColor: Colors.transparent,
            elevation: 0,
          ),
          child: Text('yes'.tr),
          onPressed: () async {
            // Perform deletion logic here
            await onPressed();
            Get.back();
          },
        ),
      ],
    ),
    transitionDuration: Duration(milliseconds: 100),
  );
}
