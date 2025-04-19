import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  SharedPreferencesUtil._();

  static Future<bool> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    bool check = await prefs.setString(key, value);
    return check;
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(key);
    return value;
  }

  static Future<bool> removeUsername(String key) async {
    final prefs = await SharedPreferences.getInstance();
    bool check = await prefs.remove(key);
    return check;
  }

  static Future<bool> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    bool check = await prefs.setBool(key, value);
    return check;
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    bool? check = prefs.getBool(key);
    return check;
  }

  static Future<bool> removeBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    bool check = await prefs.remove(key);
    return check;
  }
}
