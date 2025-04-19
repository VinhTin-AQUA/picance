import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FileUtil {
  FileUtil._();

  static Future<File> saveImageToFolderFromImageUrl(
    String imageUrl,
    String fileName,
    String folder,
  ) async {
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

    final filePath = '${baseDir.path}/$fileName';

    try {
      // Tải ảnh bằng Dio
      final response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Lưu ảnh
      final tempFile = File(filePath);
      final file = await tempFile.writeAsBytes(response.data);

      return file;
    } catch (e) {
      throw Exception('Lỗi khi tải ảnh: $e');
    }
  }

  static Future<File> saveImageToTempDirFromImageUrl(
    String imageUrl,
    String fileName,
  ) async {
    try {
      final response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final tempDir = await getTemporaryDirectory();
      final tempFilePath = path.join(tempDir.path, fileName);
      final File tempFile = File(tempFilePath);
      final file = await tempFile.writeAsBytes(response.data);

      return file;
    } catch (e) {
      throw Exception('Lỗi khi tải ảnh: $e');
    }
  }

  static Future<File> saveImageToFolderFromBytes(
    List<int> bytes,
    String fileName,
    String folder,
  ) async {
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

    final filePath = '${baseDir.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<File> saveImageToTempDirFromBytes(
    List<int> bytes,
    String fileName,
  ) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFilePath = path.join(tempDir.path, fileName);

      final File tempFile = File(tempFilePath);
      final file = await tempFile.writeAsBytes(bytes);

      return file; // Trả về đường dẫn file
    } catch (e) {
      // print('Lỗi khi lưu ảnh: $e');
      throw Exception('Failed to save image');
    }
  }
}
