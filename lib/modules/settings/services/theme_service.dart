import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picance/core/utils/shared_preferences_util.dart';

class ThemeService extends GetxService {
  // Singleton pattern
  static ThemeService get instance => Get.find();

  var themeMode = ThemeMode.light;
  bool get isDarkMode => themeMode == ThemeMode.dark;

  final _keyTheme = 'theme';
  final _keyLight = 'light';
  final _keyDark = 'dark';

  final Map<String, ThemeMode> themes = {
    "light": ThemeMode.light,
    "dark": ThemeMode.dark,
  };

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  Future<ThemeService> init() async {
    // Có thể thêm logic khởi tạo ở đây nếu cần
    return this;
  }

  // Tải theme từ SharedPreferences
  Future<void> _loadThemeFromPrefs() async {
    String? theme = await SharedPreferencesUtil.getString(_keyTheme);
    if (theme == null) {
      bool isDarkMode = Get.isDarkMode;
      themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      await SharedPreferencesUtil.setString(
        _keyTheme,
        isDarkMode ? _keyDark : _keyLight,
      );
      Get.changeThemeMode(themeMode);
      return;
    }

    if (theme == _keyDark) {
      themeMode = ThemeMode.dark;
    } else if (theme == _keyLight) {
      themeMode = ThemeMode.light;
    }

    Get.changeThemeMode(themeMode);
  }

  Future<void> changeThemeMode(ThemeMode newThemeMode) async {
    themeMode = newThemeMode;

    if (themeMode == ThemeMode.light) {
      await SharedPreferencesUtil.setString(_keyTheme, _keyLight);
    } else {
      await SharedPreferencesUtil.setString(_keyTheme, _keyDark);
    }
    Get.changeThemeMode(themeMode);
  }

  // Chuyển đổi giữa light và dark theme
  Future<void> toggleTheme() async {
    if (isDarkMode == true) {
      themeMode = ThemeMode.light;
      await SharedPreferencesUtil.setString(_keyTheme, _keyLight);
    } else {
      themeMode = ThemeMode.dark;
      await SharedPreferencesUtil.setString(_keyTheme, _keyDark);
    }
    Get.changeThemeMode(themeMode);
  }
}
