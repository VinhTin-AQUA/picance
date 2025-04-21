import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:picance/modules/image_upscaler/apis/i_love_img_api.dart';
import 'package:picance/modules/image_upscaler/apis/img_upscaler_api.dart';
import 'package:picance/modules/image_upscaler/models/scaler.dart';
import 'package:picance/modules/image_upscaler/models/imgupscaler.dart';
import 'package:image/image.dart' as img;
import '../models/iloveimgscaler.dart';

class ImageScalerController extends GetxController {
  // Danh sách các feature đã chọn (theo thứ tự)
  final Map<ImageScaleType, bool> selectedFeatures = {};

  // Map các controller
  final Map<ImageScaleType, Scaler> scales = {};

  List<String> imageFilePathPicked = [];

  // Khởi tạo tất cả controllers
  @override
  void onInit() {
    _initializeControllers();
    super.onInit();
  }

  // Lấy controller theo type
  T getScale<T extends Scaler>(ImageScaleType type) {
    return scales[type] as T;
  }

  void _initializeControllers() {
    selectedFeatures[ImageScaleType.iloveimg] = false;
    selectedFeatures[ImageScaleType.imgupscaler] = false;
  }

  void addScale(ImageScaleType type) {
    if (selectedFeatures[type] == true) {
      return;
    }

    switch (type) {
      case ImageScaleType.iloveimg:
        scales[ImageScaleType.iloveimg] = IloveimgScalerController();
        break;
      case ImageScaleType.imgupscaler:
        scales[ImageScaleType.imgupscaler] = ImgupscalerScaleController();
        break;
    }

    selectedFeatures[type] = true;
  }

  void removeScale(ImageScaleType type) {
    scales.remove(type);
    selectedFeatures[type] = false;
  }

  void toggleScale(ImageScaleType type) {
    if (selectedFeatures[type] == true) {
      removeScale(type);
    } else {
      addScale(type);
    }

    update();
  }

  void changeScale(String newScale, ImageScaleType type) {
    switch (type) {
      case ImageScaleType.iloveimg:
        final config = getScale<IloveimgScalerController>(type);
        config.scale = newScale;
        break;
      case ImageScaleType.imgupscaler:
        final config = getScale<ImgupscalerScaleController>(type);
        config.scaleRadio = newScale;
        break;
    }
    update(); // Gọi update() để thông báo thay đổi
  }

  void pickFiles(List<String> newImageFilePathPicked) {
    imageFilePathPicked = newImageFilePathPicked;
    update();
  }

  Future<String> startScale() async {
    final types = scales.keys.toList();
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    int length = types.length;
    bool latestSaved = false;

    for (int i = 0; i < length; i++) {
      if (i == length - 1) {
        latestSaved = true;
      }

      switch (types[i]) {
        case ImageScaleType.iloveimg:
          final scale = getScale<IloveimgScalerController>(types[i]);
          imageFilePathPicked = await IloveimgApi.scaling(
            imageFilePathPicked,
            scale.scale,
            timeStamp,
            latestSaved,
          );
          break;
        case ImageScaleType.imgupscaler:
          final scale = getScale<ImgupscalerScaleController>(types[i]);
          imageFilePathPicked = await ImgupscalerApi.upscaleImage(
            imageFilePathPicked,
            scale.scaleRadio,
            timeStamp,
            latestSaved,
          );
          break;
      }
    }
    return "please_open_library_to_review";
  }

  Future<bool> checkSizeOfImages(List<PlatformFile> platformFiles) async {
    for (var file in platformFiles) {
      final fileBytes = await File(file.path!).readAsBytes();
      final sizeMB = fileBytes.lengthInBytes / (1024 * 1024);
      final image = img.decodeImage(fileBytes);
      if (image == null) {
        return true;
      }

      image.getBytes();
      final areaImagePixcel = image.width * image.height;
      if (areaImagePixcel > 33177600) {
        return false;
      }

      if (sizeMB > 6) {
        return false;
      }
    }

    return true;
  }

  void cancelRequest() {
    IloveimgApi.cancelRequest();
    ImgupscalerApi.cancelRequest();
  }

  void resetState() {
    imageFilePathPicked = [];
    update();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
