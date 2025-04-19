import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picance/config/localization/app_translations.dart';
import 'package:picance/config/routes/routes.dart';
import 'package:picance/config/themes/t_app_theme.dart';
import 'package:picance/core/initialization/app_initializer.dart';
import 'package:picance/modules/settings/services/localization_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync(() => LocalizationService().init());

  runApp(MyApp());


  // Sau khi ứng dụng đã chạy, xử lý quyền
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await AppInitializer.requestPermissions();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return App();
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialRoute: TRoutes.getInitialRoute(),
      getPages: RouteGenerator.generateRoute(),
      translations: AppTranslations(),
      locale: Locale(LocalizationService.instance.currentLocale),
      fallbackLocale: const Locale('en_US'),
    );
  }
}
