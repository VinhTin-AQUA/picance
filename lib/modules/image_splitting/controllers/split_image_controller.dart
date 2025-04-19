import 'dart:io';
import 'dart:ui';
import 'package:get/get.dart';

class SplitImageController extends GetxController {
  int rows = 1;
  int cols = 2;
  Image? image;

  // Khởi tạo service
  Future<SplitImageController> init() async {
    // Có thể thêm logic khởi tạo ở đây nếu cần
    return this;
  }

  updateRows(int rows) {
    if (rows > 10) {
      this.rows = 10;
    } else {
      this.rows = rows;
    }
    update();
  }

  updateCols(int cols) {
    if (cols > 10) {
      this.cols = 10;
    } else {
      this.cols = cols;
    }
    update();
  }

  Future<void> loadImageFromAsset(String? assetPath) async {
    if (assetPath == null) {
      return;
    }

    final file = File(assetPath);
    final bytes = await file.readAsBytes();

    final codec = await instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    image = frame.image;

    update();
  }

  Future<List<Image>> splitImage() async {
    if (image == null) {
      return [];
    }
    int tileWidth = (image!.width / cols).floor();
    int tileHeight = (image!.height / rows).floor();
    List<Image> parts = [];

    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        final src = Rect.fromLTWH(
          x * tileWidth.toDouble(),
          y * tileHeight.toDouble(),
          tileWidth.toDouble(),
          tileHeight.toDouble(),
        );

        final dst = Rect.fromLTWH(
          0,
          0,
          tileWidth.toDouble(),
          tileHeight.toDouble(),
        );
        canvas.drawImageRect(image!, src, dst, Paint());

        final picture = recorder.endRecording();
        final croppedImage = await picture.toImage(tileWidth, tileHeight);
        parts.add(croppedImage);
      }
    }

    return parts;
  }

  double calculateAspectRatio() {
    if (image == null) return 1.0;
    return image!.width / image!.height;
  }
}
