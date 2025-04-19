import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:picance/core/constants/app_contants.dart';

// class LibraryScreen {}

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<Directory> folderList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImageFolders();
  }

  Future<void> _loadImageFolders() async {
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

      setState(() {
        folderList = folders;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Chuyển đổi millisecondsSinceEpoch thành chuỗi ngày tháng
  String _formatFolderName(String folderPath) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Gallery'), centerTitle: true),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : folderList.isEmpty
              ? Center(child: Text('No folders found'))
              : ListView.builder(
                itemCount: folderList.length,
                itemBuilder: (context, index) {
                  final folder = folderList[index];
                  return _buildFolderSection(folder);
                },
              ),
    );
  }

  Widget _buildFolderSection(Directory folder) {
    return FutureBuilder<List<File>>(
      future: _getImagesInFolder(folder),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final images = snapshot.data ?? [];
        if (images.isEmpty) return SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _formatFolderName(folder.path),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showFullImage(context, images[index]),
                  child: Image.file(images[index], fit: BoxFit.cover),
                );
              },
            ),
            Divider(height: 32, thickness: 1),
          ],
        );
      },
    );
  }

  Future<List<File>> _getImagesInFolder(Directory folder) async {
    try {
      final files = await folder.list().toList();
      return files.whereType<File>().toList();
    } catch (e) {
      return [];
    }
  }

  void _showFullImage(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              child: Image.file(imageFile),
            ),
          ),
    );
  }
}
