import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AppContants {
  AppContants._();

  static late final String appFolder;

  static Future<void> init() async {
    final externalStorage = await getExternalStorageDirectory();
    appFolder = path.join(externalStorage!.path, 'images');
  }
}
