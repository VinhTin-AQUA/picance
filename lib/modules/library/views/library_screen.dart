import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picance/core/utils/file_picker_util.dart';
import 'package:picance/modules/library/controllers/library_controller.dart';

// class LibraryScreen {}

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _actionFolder(
    LibraryController builder,
    int value,
    Directory folderToMoveImage,
  ) async {
    switch (value) {
      case 1:
        String? destFolder = await FilePickerUtil.pickFolder();

        if (destFolder == null) {
          return;
        }

        await builder.moveImages(folderToMoveImage, destFolder);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LibraryController>(
      builder: (builder) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Image Gallery'),
            centerTitle: true,
            actions: [],
          ),
          body:
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : builder.folderList.isEmpty
                  ? Center(child: Text('No folders found'))
                  : ListView.builder(
                    itemCount: builder.folderList.length,
                    itemBuilder: (context, index) {
                      final folder = builder.folderList[index];
                      return _buildFolderSection(builder, folder);
                    },
                  ),
        );
      },
    );
  }

  Widget _buildFolderSection(LibraryController builder, Directory folder) {
    return FutureBuilder<List<File>>(
      future: builder.getImagesInFolder(folder),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    builder.formatFolderName(folder.path),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  PopupMenuButton<int>(
                    onSelected: (value) async {
                      await _actionFolder(builder, value, folder);
                    },
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(
                            value: 1,
                            child: Text('Move'),
                          ),
                          PopupMenuItem(value: 2, child: Text('Delete')),
                        ],
                  ),
                ],
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
