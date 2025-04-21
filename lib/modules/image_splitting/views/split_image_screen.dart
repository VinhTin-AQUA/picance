import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picance/core/constants/app_contants.dart';
import 'package:picance/core/utils/file_util.dart';
import 'package:picance/modules/image_splitting/controllers/split_image_controller.dart';
import 'package:picance/modules/image_splitting/widgets/grid_painter.dart';
import 'package:picance/modules/image_splitting/widgets/number_input_field.dart';
import 'package:picance/modules/image_splitting/widgets/split_dialog_loading.dart';
import 'package:picance/shared/widgets/notification_dialog.dart';

class SplitImageData extends ChangeNotifier {
  int _rows = 2;
  int _cols = 2;

  int get rows => _rows;
  int get cols => _cols;

  set rows(int value) {
    _rows = value;
    notifyListeners();
  }

  set cols(int value) {
    _cols = value;
    notifyListeners();
  }
}

// SplitImageScreen

class SplitImageScreen extends StatefulWidget {
  const SplitImageScreen({super.key});

  @override
  State<SplitImageScreen> createState() => _SplitImageScreenState();
}

class _SplitImageScreenState extends State<SplitImageScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplitImageController>(
      builder: (builder) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'split_image'.tr,
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("${'rows'.tr}:"),
                      const SizedBox(width: 8),
                      Expanded(
                        child: NumberInputField(
                          initialValue: builder.rows,
                          onValueChanged: (newValue) {
                            builder.updateRows(
                              newValue,
                            ); // Cập nhật giá trị cols khi người dùng nhập
                          },
                        ),
                      ),
                      const SizedBox(width: 24),
                      Text("${'cols'.tr}:"),
                      const SizedBox(width: 8),
                      Expanded(
                        child: NumberInputField(
                          initialValue: builder.cols,
                          onValueChanged: (newValue) {
                            builder.updateCols(
                              newValue,
                            ); // Cập nhật giá trị cols khi người dùng nhập
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(),
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        await builder.loadImageFromAsset();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 3, // Độ nổi (bóng đổ)
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Icon(Icons.add_photo_alternate_outlined),
                    ),
                  ),

                  builder.image == null
                      ? SizedBox(child: Container())
                      : Expanded(
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color.fromARGB(255, 255, 255, 255),
                                Colors.transparent,
                              ],
                              stops: [0.99, 1.0],
                            ).createShader(bounds);
                          },
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio:
                                        builder
                                            .calculateAspectRatio(), // Tính tỷ lệ dựa trên ảnh
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        RawImage(
                                          image: builder.image,
                                          fit:
                                              BoxFit
                                                  .contain, // Giữ nguyên tỷ lệ
                                        ),
                                        CustomPaint(
                                          painter: GridPainter(
                                            rows: builder.rows,
                                            columns: builder.cols,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await start(builder);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ), // Bo góc
                                        ),
                                        elevation: 3, // Độ nổi (bóng đổ)
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      child: Text('start'.tr),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> start(SplitImageController builder) async {
    SplitDialogLoading.showUpscaleLoadingDialog();

    final parts = await builder.splitImage();
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    int i = 1;
    String appFolder = AppContants.appFolder;

    for (final part in parts) {
      final byteData = await part.toByteData(format: ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();
      await FileUtil.saveImageToFolderFromBytes(
        bytes,
        "${builder.fileName}_$i.png",
        "$appFolder/$timeStamp",
      );

      i++;
    }

    Get.back();
    showNotificationDialog(
      success: true,
      title: "successfully".tr,
      message: "please_open_library_to_review".tr,
    );
  }
}
