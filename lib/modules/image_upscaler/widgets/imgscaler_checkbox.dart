import 'package:flutter/material.dart';
import '../models/scaler.dart';
import '../controllers/imagescaler_controller.dart';

class ImgScalerCheckBox extends StatefulWidget {
  final ImageScalerController builder;
  final ImageScaleType imageScaleType;

  const ImgScalerCheckBox({
    super.key,
    required this.builder,
    required this.imageScaleType,
  });

  @override
  State<ImgScalerCheckBox> createState() => _ImgScalerCheckBoxState();
}

class _ImgScalerCheckBoxState extends State<ImgScalerCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: widget.builder.selectedFeatures[widget.imageScaleType],
          onChanged: (value) {
            widget.builder.toggleScale(widget.imageScaleType);
          },
        ),
        const SizedBox(width: 8),
        Icon(Icons.task_alt, color: _getTextColor(context)),
        const SizedBox(width: 8),
        Text(
          widget.imageScaleType.label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color:
                widget.builder.selectedFeatures[widget.imageScaleType] == true
                    ? Colors.indigo
                    : _getTextColor(context),
          ),
        ),
      ],
    );
  }

  Color _getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
}
