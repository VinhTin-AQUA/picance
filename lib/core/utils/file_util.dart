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

      return file;
    } catch (e) {
      throw Exception('Failed to save image');
    }
  }

  static Future<void> moveImage(
    String sourcePath,
    String destinationDir,
  ) async {
    try {
      // Lấy file từ đường dẫn nguồn
      File sourceFile = File(sourcePath);

      // Kiểm tra file tồn tại
      if (!await sourceFile.exists()) {
        throw Exception('File nguồn không tồn tại');
      }

      // Tạo thư mục đích nếu chưa có
      Directory(destinationDir).createSync(recursive: true);

      // Lấy tên file từ đường dẫn nguồn
      String fileName = path.basename(sourcePath);

      // Tạo đường dẫn đích
      String destinationPath = path.join(destinationDir, fileName);

      // Di chuyển file
      await sourceFile.rename(destinationPath);
    } catch (e) {
      await copyAndDelete(sourcePath, destinationDir);
    }
  }

  static Future<void> copyAndDelete(
    String sourcePath,
    String destinationDir,
  ) async {
    try {
      File sourceFile = File(sourcePath);
      String fileName = path.basename(sourcePath);
      String destinationPath = path.join(destinationDir, fileName);

      // Copy file
      await sourceFile.copy(destinationPath);

      // Xóa file gốc
      await sourceFile.delete();
    } catch (e) {
      //
    }
  }

  static Future<void> removeFile(String path) async {
    File sourceFile = File(path);
    await sourceFile.delete();
  }
}
