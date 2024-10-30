import 'package:flutter/material.dart';
import 'package:mobicraft/flutter_generator/flutter_generator.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/padding/attributes/padding_attributes.dart';

class AppPadding extends BaseWidget{
  @override
    Widget generate(Map<String, dynamic> attributes) {
      return Padding(
        padding: attributes[PaddingAttributeKeys.padding] as EdgeInsets? ?? const EdgeInsets.all(0),
        child: FlutterGenerator.generate(attributes[PaddingAttributeKeys.child]),
      );

  }

}