import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerUtil {
  PermissionHandlerUtil._();

  static Future<bool> requestManageExternalStoragePermission() async {
    var status = await Permission.photos.status;

    if (status.isGranted) {
      return true;
    }

    var r = await Permission.photos.request();
    return r.isGranted;
  }

  static Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;

    if (status.isGranted) {
      return true;
    }

    var r = await Permission.storage.request();
    print(r.isGranted);
    return r.isGranted;
  }
}
