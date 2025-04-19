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
            const Text(
              'Không có kết nối Internet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Vui lòng kiểm tra kết nối mạng và thử lại'),
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
                  Get.toNamed('/home', );
                }
              },
              child: const Text('Thử lại'),
            ),
            isChecking == true
                ? const CircularProgressIndicator()
                : Container(),
          ],
        ),
      ),
    );
  }
}
