import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:picance/core/utils/file_picker_util.dart';
import 'package:picance/modules/gallary/controllers/library_controller.dart';
import 'package:picance/shared/widgets/question_dialog.dart';

class FolderSection extends StatefulWidget {
  final LibraryController builder;
  final Directory folder;

  const FolderSection({super.key, required this.builder, required this.folder});

  @override
  State<FolderSection> createState() => _FolderSectionState();
}

class _FolderSectionState extends State<FolderSection> {
  Future<void> _actionFolder(
    LibraryController builder,
    int value,
    Directory folder,
  ) async {
    switch (value) {
      case 1:
        String? destFolder = await FilePickerUtil.pickFolder();
      
        if (destFolder == null) {
          return;
        }
        await builder.moveImages(folder, destFolder);
        break;
      case 2:
        questionDialog(
          message: "delete_this_folder_?".tr,
          onPressed: () async {
            await builder.removeFolder(folder);
          },
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<File>>(
      future: widget.builder.getImagesInFolder(widget.folder),
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
                    widget.builder.formatFolderName(widget.folder.path),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  PopupMenuButton<int>(
                    onSelected: (value) async {
                      await _actionFolder(widget.builder, value, widget.folder);
                    },
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(value: 1, child: Text('move'.tr)),
                          PopupMenuItem(value: 2, child: Text('delete'.tr)),
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
