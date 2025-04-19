import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpscaleDialogLoading {
  UpscaleDialogLoading._();

  static void showUpscaleLoadingDialog(void Function() cancelRequest) {
    Get.generalDialog(
      pageBuilder: (context, animation, secondaryAnimation) {
        return CustomLoadingDialog(cancelRequest: cancelRequest);
      },
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.0, end: 1.0).animate(anim),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(anim),
            child: child,
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
    );
  }
}

class CustomLoadingDialog extends StatelessWidget {
  final void Function() cancelRequest;

  const CustomLoadingDialog({super.key, required this.cancelRequest});

  @override
  Widget build(BuildContext context) {
    var size = Get.mediaQuery.size;
    return AlertDialog(
      content: SizedBox(
        height: size.height / 4,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              'Loading...',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: size.width,
              child: Text(
                "Result: 1",
                textAlign: TextAlign.center,
                style: Get.theme.textTheme.headlineSmall,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: size.width,
              child: ElevatedButton(
                onPressed: () {
                  cancelRequest();
                },
                child: Text("Stop"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
