import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TRadioListTileTheme {
  TRadioListTileTheme._();

  static Color color() =>
      Get.isDarkMode == false ? Color(0xffe11d48) : Colors.white;

}
