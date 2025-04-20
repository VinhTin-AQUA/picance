import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picance/modules/gallary/controllers/library_controller.dart';
import 'package:picance/modules/gallary/widget/folder_section.dart';

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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LibraryController>(
      builder: (builder) {
        return Scaffold(
          appBar: AppBar(
            title: Text('gallary'.tr),
            centerTitle: true,
            actions: [],
          ),
          body:
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : builder.folderList.isEmpty
                  ? Center(child: Text('no_folders_found'.tr))
                  : ListView.builder(
                    itemCount: builder.folderList.length,
                    itemBuilder: (context, index) {
                      final folder = builder.folderList[index];
                      return FolderSection(builder: builder, folder: folder);
                    },
                  ),
        );
      },
    );
  }
}
