import 'package:file_picker/file_picker.dart';

class FilePickerUtil {
  FilePickerUtil._();

  static Future<String> pickFolder() async {
    try {
      String? folderPath = await FilePicker.platform.getDirectoryPath();

      if (folderPath != null) {
        // In ra đường dẫn thư mục đã chọn
        return folderPath;
      }
      return "Empty Folder";
    } catch (e) {
      return "error";
    }
  }

  static Future<List<PlatformFile>> pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null) {
        return result.files;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
