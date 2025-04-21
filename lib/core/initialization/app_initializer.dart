// lib/core/initialization/app_initializer.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:picance/core/constants/app_contants.dart';
import 'package:picance/core/utils/folder_util.dart';
import 'package:picance/core/utils/permission_handler_util.dart';

class AppInitializer {
  AppInitializer._();

  static Future<void> initialize() async {
    // Initialize in the main isolate first
    await AppContants.init(); // Initialize constants first
    await FolderUtil.createFolder(AppContants.appFolder); // Then use them

    // Get the root isolate token in the main isolate
    final rootIsolateToken = RootIsolateToken.instance!;

    await compute(_initInBackground, rootIsolateToken);
  }

  static Future<void> _initInBackground(RootIsolateToken token) async {
    // Initialize the messenger with the token
    BackgroundIsolateBinaryMessenger.ensureInitialized(token);

    // Now you can safely use path_provider
    // await FolderUtil.createFolder(AppContants.appFolder);
  }

  // check permission
  static Future<bool> requestPermissions() async {
    final r = await PermissionHandlerUtil.requestPhotoPermission();
    return r;
  }
}
