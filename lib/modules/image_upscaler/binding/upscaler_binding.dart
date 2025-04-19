import 'package:get/get.dart';
import 'package:picance/modules/image_upscaler/controllers/imagescaler_controller.dart';

class UpscalerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageScalerController>(() => ImageScalerController());
  }
}
