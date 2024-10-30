import 'package:flutter/material.dart';
import 'package:mobicraft/flutter_generator/flutter_generator.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/row/attributes/row_attributes.dart';
import 'package:mobicraft/widgets/ui_element.dart';

class AppRow extends BaseWidget {
  @override
  Widget generate(Map<String, dynamic> attributes) {
    return  Row(
      mainAxisAlignment: attributes[RowAttributeKeys.mainAxisAlignment] as MainAxisAlignment? ?? MainAxisAlignment.start,
      crossAxisAlignment: attributes[RowAttributeKeys.crossAxisAlignment] as CrossAxisAlignment? ?? CrossAxisAlignment.center,
      mainAxisSize: attributes[RowAttributeKeys.mainAxisSize] as MainAxisSize? ?? MainAxisSize.max,
      textDirection: attributes[RowAttributeKeys.textDirection] as TextDirection?,
      verticalDirection: attributes[RowAttributeKeys.verticalDirection] as VerticalDirection? ?? VerticalDirection.down,
      children: (attributes[RowAttributeKeys.children] as List<UIElement>)
          .map((childElement) => FlutterGenerator.generate(childElement))
          .toList(),
    );
  }

}