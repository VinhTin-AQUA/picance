import 'package:picance/modules/image_upscaler/models/scaler.dart';

class IloveimgScalerController extends Scaler {
  @override
  final ImageScaleType featureType = ImageScaleType.iloveimg;

  String scale = '2';
  final List<String> optionScales = ["2", "4"];
}
