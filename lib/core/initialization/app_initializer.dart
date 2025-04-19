// lib/core/initialization/app_initializer.dart
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:picance/core/constants/app_contants.dart';
import 'package:picance/core/utils/permission_handler_util.dart';

class AppInitializer {
  AppInitializer._();

  static Future<void> initialize() async {
    await compute(_initializeInBackground, null);
  }

  static void _initializeInBackground(_) async {
    await _createAppDirectories();
  }

  static Future<void> _createAppDirectories() async {
    String savingFolder = AppContants.appFolder;
    Directory? baseDir;

    // Dùng cho Android: lưu ở thư mục /Pictures/YourAppName
    if (Platform.isAndroid) {
      baseDir = Directory(savingFolder);
    } else {
      // iOS hoặc fallback: dùng documents directory
      baseDir = await getApplicationDocumentsDirectory();
      baseDir = Directory(path.join(baseDir.path, 'Images'));
    }

    if (!(await baseDir.exists())) {
      await baseDir.create(recursive: true);
    }
  }

  // check internet


  // check permission
  static Future<void> requestPermissions() async {
    await PermissionHandlerUtil.requestManageExternalStoragePermission();
  }
}
