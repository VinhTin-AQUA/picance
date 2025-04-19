import 'package:get/get.dart';
import 'package:picance/config/localization/locales/en_us.dart';
import 'package:picance/config/localization/locales/vi_vn.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUS, 'vi_VN': viVN};
}
