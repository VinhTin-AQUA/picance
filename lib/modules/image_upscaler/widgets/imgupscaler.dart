import 'package:flutter/material.dart';
import 'package:picance/config/themes/t_dropdownbutton_theme.dart';
import 'package:picance/modules/image_upscaler/models/scaler.dart';
import 'package:picance/modules/image_upscaler/controllers/imagescaler_controller.dart';
import 'package:picance/modules/image_upscaler/models/imgupscaler.dart';

import '../../../config/themes/t_container.dart';

class ImgUpscaler extends StatefulWidget {
  final ImageScalerController builder;
  final ImageScaleType type;

  const ImgUpscaler({super.key, required this.builder, required this.type});

  @override
  State<ImgUpscaler> createState() => _ImgUpscalerState();
}

class _ImgUpscalerState extends State<ImgUpscaler> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: TContainerTheme.boxDecoration(context),
      child: Column(
        children: [
          Container(
            width: size.width,
            decoration: BoxDecoration(),
            child: Text(
              widget.type.label,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Scale:"),
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffe11d48), // màu của border
                          width: 1.2, // độ dày của border
                        ),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value:
                            widget.builder
                                .getScale<ImgupscalerScaleController>(
                                  widget.type,
                                )
                                .scaleRadio,
                        icon: Icon(Icons.arrow_drop_down),
                        dropdownColor: TDropdownButtonTheme.dropdownColor(
                          context,
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            widget.builder.changeScale(newValue, widget.type);
                          }
                        },
                        items:
                            widget.builder
                                .getScale<ImgupscalerScaleController>(
                                  widget.type,
                                )
                                .optionScales
                                .map((fruit) {
                                  return DropdownMenuItem(
                                    value: fruit,
                                    child: Text(fruit),
                                  );
                                })
                                .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
