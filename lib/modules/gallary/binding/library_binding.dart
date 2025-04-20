import 'package:get/get.dart';
import 'package:picance/modules/gallary/controllers/library_controller.dart';

class LibraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LibraryController>(() => LibraryController());
  }
}
