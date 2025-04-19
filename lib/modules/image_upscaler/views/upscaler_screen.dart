import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picance/config/themes/t_elevated_button_theme.dart';
import 'package:picance/modules/image_upscaler/controllers/imagescaler_controller.dart';
import 'package:picance/modules/image_upscaler/widgets/imgscaler_checkbox.dart';
import 'package:picance/modules/image_upscaler/widgets/upscale_dialog_loading.dart';
import 'package:picance/shared/widgets/show_notification_dialog.dart';
import 'package:image/image.dart' as img;
import '../../../core/utils/file_picker_util.dart';
import '../models/scaler.dart';
import '../widgets/iloveimg.dart';
import '../widgets/imgupscaler.dart';

class UpscaleImageScreen extends StatelessWidget {
  static bool _dialogClosed = false;

  const UpscaleImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageScalerController>(
      builder: (builder) {
        return Scaffold(
          appBar: AppBar(title: Text('upscaler'.tr), centerTitle: true),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "${builder.imageFilePathPicked.length.toString()} ${"images".tr}",
                          style: Theme.of(context).textTheme.titleSmall,
                          softWrap: true,
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: TElevatedButtonTheme.pressButton(
                            Colors.indigo,
                            Colors.amber,
                          ),
                          // Có thể copy các thuộc tính khác từ theme
                          elevation:
                              Theme.of(
                                context,
                              ).elevatedButtonTheme.style?.elevation,
                          // ... các thuộc tính khác
                        ),
                        onPressed: () async {
                          await pickFiles(builder);
                        },
                        child: const Icon(Icons.folder),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Divider(
                    color: Colors.grey, // Màu của đường kẻ
                    thickness: 2, // Độ dày
                    height: 20, // Khoảng cách trên và dưới đường kẻ
                    // indent: 20, // Thụt lề bên trái
                    // endIndent: 20, // Thụt lề bên phải
                  ),
                  SizedBox(height: 10),
                  Text(
                    'selected_methods'.tr,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ...builder.selectedFeatures.keys.map(
                    (imageScaleType) => ImgScalerCheckBox(
                      builder: builder,
                      imageScaleType: imageScaleType,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'methods'.tr,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      ...builder.scales.keys.map((type) {
                        if (!builder.selectedFeatures.keys.contains(type)) {
                          return Container();
                        }

                        switch (type) {
                          case ImageScaleType.iloveimg:
                            return ILoveImg(builder: builder, type: type);
                          case ImageScaleType.imgupscaler:
                            return ImgUpscaler(builder: builder, type: type);
                        }
                      }),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await scale(builder);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5), // Bo góc
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
        );
      },
    );
  }

  static Future<void> pickFiles(ImageScalerController builder) async {
    final platformFiles = await FilePickerUtil.pickFiles();

    for (var file in platformFiles) {
      final fileBytes = await File(file.path!).readAsBytes();

      final sizeMB = fileBytes.lengthInBytes / (1024 * 1024);

      final image = img.decodeImage(fileBytes);

      if (image == null) {
        return;
      }

      image.getBytes();

      final areaImage = image.width * image.height;

      if (areaImage > 33177600) {
        showNotificationDialog(
          success: false,
          title: "out_of_pxsize".tr,
          message: "${'image_name'.tr}: ${file.name}",
        );
        return;
      }

      if (sizeMB > 6) {
        showNotificationDialog(
          success: false,
          title: "out_of_byte".tr,
          message: "${'image_name'.tr}: ${file.name}",
        );
        return;
      }
    }

    final List<String> paths =
        platformFiles
            .where((f) => f.path != null && f.path!.isNotEmpty)
            .map((f) => f.path!)
            .toList();

    builder.pickFiles(paths);
  }

  static Future<void> scale(ImageScalerController builder) async {
    if (builder.scales.isEmpty == true) {
      showNotificationDialog(
        success: false,
        title: "no_method".tr,
        message: "please_select_at_least_one_method".tr,
      );
      return;
    }

    if (builder.imageFilePathPicked.isEmpty == true) {
      showNotificationDialog(
        success: false,
        title: "no_img".tr,
        message: "please_select_at_least_one_image".tr,
      );
      return;
    }

    _dialogClosed = false;

    UpscaleDialogLoading.showUpscaleLoadingDialog(() {
      builder.cancelRequest();
      Get.back();
      _dialogClosed = true;
    });

    final message = await builder.startScale();

    if (_dialogClosed == true) {
      return;
    }

    Get.back();
    _dialogClosed = true;

    showNotificationDialog(
      success: true,
      title: "successfully".tr,
      message: message.tr,
    );

    builder.resetState();
  }
}
