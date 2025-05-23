import 'package:get/get.dart';
import 'package:picance/modules/image_upscaler/apis/i_love_img_api.dart';
import 'package:picance/modules/image_upscaler/apis/img_upscaler_api.dart';
import 'package:picance/modules/image_upscaler/models/scaler.dart';
import 'package:picance/modules/image_upscaler/models/imgupscaler.dart';

import '../models/iloveimgscaler.dart';

class ImageScalerController extends GetxController {
  final Map<ImageScaleType, bool> selectedFeatures = {};
  final Map<ImageScaleType, Scaler> scales = {};
  List<String> imageFilePathPicked = [];
  int isStarted = 0;

  @override
  void onInit() {
    _initializeControllers();
    super.onInit();
  }

  T getScale<T extends Scaler>(ImageScaleType type) {
    return scales[type] as T;
  }

  void _initializeControllers() {
    selectedFeatures[ImageScaleType.iloveimg] = false;
    selectedFeatures[ImageScaleType.imgupscaler] = false;
  }

  void setIsStarted(int flag) {
    isStarted = flag;
    update();
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
    update();
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

  void cancelRequest() {
    IloveimgApi.cancelRequest();
    ImgupscalerApi.cancelRequest();
  }

  void resetState() {
    imageFilePathPicked = [];
    isStarted = 0;
    update();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
