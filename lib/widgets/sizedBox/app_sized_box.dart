import 'package:flutter/material.dart';
import 'package:mobicraft/flutter_generator/flutter_generator.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/sizedBox/attributes/sized_box_attributes.dart';

class AppSizedBox extends BaseWidget {
  @override
  Widget generate(Map<String, dynamic> attributes) {
    return SizedBox(
      width: attributes[SizedBoxAttributeKeys.width] as double?,
      height: attributes[SizedBoxAttributeKeys.height] as double?,
      child: FlutterGenerator.generate(attributes[SizedBoxAttributeKeys.child]),
    );
  }
}