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
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFE11D48), // Màu viền khi focus
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xfffda4af), // Màu viền khi không focus
            width: 1.0,
          ),
        ),
      ),
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
