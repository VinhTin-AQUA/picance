import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picance/core/utils/connectivity_plus_util.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool isChecking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              'no_internet'.tr,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'please_check_your_network_connection_and_try_again'.tr,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  isChecking = true;
                });
                // Thử kiểm tra lại kết nối
                final isCheckingInternet =
                    await ConnectivityPlusUtil.checkInternet();

                setState(() {
                  isChecking = false;
                });
                if (isCheckingInternet == true) {
                  Get.toNamed('/home');
                }
              },
              child: Text('try_again'.tr),
            ),
            SizedBox(height: 10),
            isChecking == true
                ? SizedBox(height: 37, child: const CircularProgressIndicator())
                : SizedBox(height: 37),
          ],
        ),
      ),
    );
  }
}
