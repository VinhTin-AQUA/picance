import 'package:get/get.dart';
import 'package:picance/modules/image_splitting/controllers/split_image_controller.dart';

class SplitImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplitImageController>(() => SplitImageController());
  }
}

