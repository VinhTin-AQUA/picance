import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:get/utils.dart';

class SplitImageData extends ChangeNotifier {
  int _rows = 2;
  int _cols = 2;

  int get rows => _rows;
  int get cols => _cols;

  set rows(int value) {
    _rows = value;
    notifyListeners();
  }

  set cols(int value) {
    _cols = value;
    notifyListeners();
  }
}

// SplitImageScreen

class SplitImageScreen extends StatefulWidget {
  const SplitImageScreen({super.key});

  @override
  State<SplitImageScreen> createState() => _SplitImageScreenState();
}

class _SplitImageScreenState extends State<SplitImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('split_image'.tr, style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Text('Rows:'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Chỉ cho nhập số
                      ],
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: '2'),
                      onChanged: (value) {
                        if (value.isEmpty) return;

                        final intValue = int.tryParse(value);
                        if (intValue == null || intValue < 1) {}
                      },
                    ),
                  ),
                  const SizedBox(width: 24),
                  const Text('Cols:'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Chỉ cho nhập số
                      ],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: '2'),
                      onChanged: (value) {
                        if (value.isEmpty) return;

                        final intValue = int.tryParse(value);
                        if (intValue == null || intValue < 1) {}
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(child: Container()),
              // const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5), // Bo góc
                    ),
                    elevation: 3, // Độ nổi (bóng đổ)
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('start'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
