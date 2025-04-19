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
    final status = await Permission.storage.request();

    if (status.isPermanentlyDenied) {
      await openAppSettings(); // Chỉ mở Settings nếu bị từ chối vĩnh viễn
    }

    return status.isGranted;
  }
}
