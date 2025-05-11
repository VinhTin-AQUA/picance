import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picance/config/routes/routes.dart';
import 'package:picance/core/initialization/app_initializer.dart';
import 'package:picance/core/utils/connectivity_plus_util.dart';
import 'package:picance/modules/settings/services/theme_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    Get.put(ThemeService());

    final isCheckingInternet = await ConnectivityPlusUtil.checkInternet();

    if (isCheckingInternet == false) {
      await Future.delayed(const Duration(seconds: 2));

      Get.toNamed('/no-internet');
      return;
    }

    await Future.wait([]);

    // 2. Thực hiện các khởi tạo khác
    await AppInitializer.initialize();

    // 3. Chạy garbage collector trước khi chuyển
    WidgetsBinding.instance.performReassemble();
    await Future.delayed(const Duration(seconds: 2));

    // 4. Chuyển đến route chính
    Get.offNamed('/');
    final r = await AppInitializer.requestPermissions();
    if (r == false) {
      Get.offNamed(TRoutes.requestAccessImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.black : Color(0xFFE11D48),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 150, // tùy chỉnh kích thước
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
