import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FolderUtil {
  FolderUtil._();

  static Future<void> createFolder(String folder) async {
    Directory? baseDir;

    // Dùng cho Android: lưu ở thư mục /Pictures/YourAppName
    if (Platform.isAndroid) {
      baseDir = Directory(folder);
    } else {
      // iOS hoặc fallback: dùng documents directory
      baseDir = await getApplicationDocumentsDirectory();
      baseDir = Directory(path.join(baseDir.path, 'Images'));
    }

    if (!(await baseDir.exists())) {
      await baseDir.create(recursive: true);
    }
  }
}
