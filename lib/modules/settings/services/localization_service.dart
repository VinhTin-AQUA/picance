import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:picance/core/utils/shared_preferences_util.dart';

class LocalizationService extends GetxService {
  // Singleton pattern
  static LocalizationService get instance => Get.find();

  final Map<String, String> supportedLocales = {
    'en_US': 'English',
    'vi_VN': 'Tiếng Việt',
  };
  String currentLocale = 'en_US';
  final _keyLocale = "locale";

  @override
  void onInit() {
    super.onInit();
    _loadLocaleFromPrefs();
  }

  Future<void> _loadLocaleFromPrefs() async {
    String? locale = await SharedPreferencesUtil.getString(_keyLocale);

    if (locale == null) {
      currentLocale = "en_US";

      await SharedPreferencesUtil.setString(_keyLocale, currentLocale);
      Get.updateLocale(Locale(currentLocale));
      return;
    }

    currentLocale = locale;
    Get.updateLocale(Locale(currentLocale));
  }

  // Khởi tạo service
  Future<LocalizationService> init() async {
    // Có thể thêm logic khởi tạo ở đây nếu cần
    return this;
  }

  // Phương thức thay đổi ngôn ngữ
  Future<void> changeLocale(String localeCode) async {
    if (supportedLocales.containsKey(localeCode)) {
      currentLocale = localeCode;
      Get.updateLocale(Locale(localeCode));

      await SharedPreferencesUtil.setString(_keyLocale, currentLocale);
      // Get.forceAppUpdate();
    }
  }

  // Phương thức dịch trực tiếp (không dùng .tr)
  String translate(String key) {
    final translations = Get.translations;
    if (translations.containsKey(currentLocale)) {
      return translations[currentLocale]![key] ?? key;
    }
    return key;
  }
}
