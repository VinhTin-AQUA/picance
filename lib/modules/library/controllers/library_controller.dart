import 'dart:io';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:picance/core/constants/app_contants.dart';
import 'package:picance/core/utils/file_util.dart';
import 'package:picance/core/utils/folder_util.dart';

class LibraryController extends GetxController {
  int resultMoveImage = 0;
  List<Directory> folderList = [];

  @override
  void onInit() {
    super.onInit();
    // Gọi hàm init của bạn ở đây
    loadImageFolders();
  }

  Future<void> loadImageFolders() async {
    // Lấy đường dẫn đến thư mục Pictures
    final picturesDir = Directory(AppContants.appFolder);

    if (await picturesDir.exists()) {
      // Lấy danh sách các thư mục con
      final folders =
          await picturesDir
              .list()
              .where((entity) => entity is Directory)
              .cast<Directory>()
              .toList();

      // Sắp xếp theo thời gian (mới nhất đầu tiên)
      folders.sort((a, b) => b.path.compareTo(a.path));
      folderList = folders;

      update();
    }
  }

  // Chuyển đổi millisecondsSinceEpoch thành chuỗi ngày tháng
  String formatFolderName(String folderPath) {
    try {
      final folderName = folderPath.split('/').last;
      final timestamp = int.tryParse(folderName);
      if (timestamp != null) {
        final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
        return DateFormat('dd/MM/yyyy - HH:mm:ss').format(date);
      }
      return folderName;
    } catch (e) {
      return folderPath.split('/').last;
    }
  }

  Future<List<File>> getImagesInFolder(Directory folder) async {
    try {
      final files = await folder.list().toList();
      return files.whereType<File>().toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> moveImages(Directory folder, String destFolder) async {
    final future = await getImagesInFolder(folder);
    final destinationDir = destFolder;

    if (future.isEmpty == true) {
      return;
    }

    for (final i in future) {
      await FileUtil.moveImage(i.path, destinationDir);
    }
    await FolderUtil.removeFolder(folder.path);

    folderList.remove(folder);
    update();
  }
}
