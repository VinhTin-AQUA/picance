enum ImageScaleType {
  iloveimg('ILoveIMG'),
  imgupscaler('ImgUpscaler');

  final String label;

  const ImageScaleType(this.label);
}

// Base class cho tất cả các feature controller
abstract class Scaler {
  ImageScaleType get featureType;
  bool isActive = false;
}
