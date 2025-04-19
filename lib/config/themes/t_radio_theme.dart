import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TRadioListTileTheme {
  TRadioListTileTheme._();

  static Color color() =>
      Get.isDarkMode == false ? Colors.indigo : Colors.white;

}
