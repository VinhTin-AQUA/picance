import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberInputField extends StatefulWidget {
  final int initialValue;
  final Function(int) onValueChanged;

  const NumberInputField({
    super.key,
    required this.initialValue,
    required this.onValueChanged,
  });

  @override
  State<NumberInputField> createState() => _NumberInputFieldState();
}

class _NumberInputFieldState extends State<NumberInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
 print("=======================");
    print(widget.initialValue);
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(border: OutlineInputBorder()),
      controller: _controller,
      onChanged: (value) {
       
        if (value.isEmpty) return;

        final intValue = int.tryParse(value) ?? 1;

        if (intValue > 10) {
          widget.onValueChanged(10);
          _controller.text = "10";
        } else {
          widget.onValueChanged(intValue);
          _controller.text = intValue.toString();
        }
      },
    );
  }
}
