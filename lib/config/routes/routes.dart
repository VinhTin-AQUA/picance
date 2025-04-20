import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picance/modules/image_splitting/binding/split_image_binding.dart';
import 'package:picance/modules/image_splitting/views/split_image_screen.dart';
import 'package:picance/modules/image_upscaler/binding/upscaler_binding.dart';
import 'package:picance/modules/image_upscaler/views/upscaler_screen.dart';
import 'package:picance/modules/gallary/binding/library_binding.dart';
import 'package:picance/modules/gallary/views/library_screen.dart';
import 'package:picance/modules/settings/views/settings.dart';
import 'package:picance/shared/screens/home_screen.dart';
import 'package:picance/shared/screens/no_internet_screen.dart';
import 'package:picance/shared/screens/splash_screen.dart';

class TRoutes {
  static const home = '/';
  static const upscaler = '/upscaler';
  static const splitImage = '/split-image';
  static const settings = '/settings';
  static const splashs = '/splashs';
  static const noInternet = '/no-internet';
  static const library = '/library';

  static String getInitialRoute() {
    return splashs;
  }
}

class RouteGenerator {
  static const milliseconds = 150;

  static List<GetPage<dynamic>> generateRoute() => [
    GetPage(
      name: TRoutes.home,
      page: () => HomeScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: milliseconds),
      curve: Curves.easeOut,
    ),
    GetPage(
      name: TRoutes.upscaler,
      page: () => UpscaleImageScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: milliseconds),
      curve: Curves.easeOut,
      binding: UpscalerBinding(),
    ),
    GetPage(
      name: TRoutes.splitImage,
      page: () => SplitImageScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: milliseconds),
      curve: Curves.easeOut,
      binding: SplitImageBinding()
    ),
    GetPage(
      name: TRoutes.settings,
      page: () => SettingsScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: milliseconds),
      curve: Curves.easeOut,
    ),
    GetPage(
      name: TRoutes.splashs,
      page: () => SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: milliseconds),
      curve: Curves.easeOut,
    ),
    GetPage(
      name: TRoutes.noInternet,
      page: () => NoInternetScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: milliseconds),
      curve: Curves.easeOut,
    ),
    GetPage(
      name: TRoutes.library,
      page: () => LibraryScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: milliseconds),
      curve: Curves.easeOut,
      binding: LibraryBinding(),
    ),
  ];
}
