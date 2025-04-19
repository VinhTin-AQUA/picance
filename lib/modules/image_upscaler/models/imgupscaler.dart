import 'package:picance/modules/image_upscaler/models/scaler.dart';

class ImgupscalerScaleController extends Scaler {
  @override
  final ImageScaleType featureType = ImageScaleType.imgupscaler;

  String scaleRadio = '2';
  final List<String> optionScales = ["2", "4"];
}
