import 'package:flutter/material.dart';
import 'package:picance/core/utils/permission_handler_util.dart';

class ImageAccessRequestScreen extends StatelessWidget {
  const ImageAccessRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Access Request'), centerTitle: true,),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.photo_library, size: 100.0, color: Colors.blue),
              const SizedBox(height: 20.0),
              const Text(
                'We need access to your photos to continue.',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Please grant us permission to access your image library. This will allow us to upload or process your images as required.',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () async {
                  await PermissionHandlerUtil.openSettings();
                },
                child: const Text(
                  'Grant Access',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
