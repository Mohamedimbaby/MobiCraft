import 'package:flutter/material.dart';
import 'package:mobicraft/flutter_generator/flutter_generator.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/column/attributes/column_attributes.dart';
import 'package:mobicraft/widgets/ui_element.dart';

class ColumnAttributes extends BaseWidget {
  @override
  Widget generate(Map<String, dynamic> attributes) {
    return Column(
      mainAxisAlignment: attributes[ColumnAttributeKeys.mainAxisAlignment] as MainAxisAlignment? ?? MainAxisAlignment.start,
      crossAxisAlignment: attributes[ColumnAttributeKeys.crossAxisAlignment] as CrossAxisAlignment? ?? CrossAxisAlignment.center,
      mainAxisSize: attributes[ColumnAttributeKeys.mainAxisSize] as MainAxisSize? ?? MainAxisSize.max,
      textDirection: attributes[ColumnAttributeKeys.textDirection] as TextDirection?,
      verticalDirection: attributes[ColumnAttributeKeys.verticalDirection] as VerticalDirection? ?? VerticalDirection.down,
      children: (attributes[ColumnAttributeKeys.children] as List<UIElement>)
          .map((childElement) => FlutterGenerator.generate(childElement))
          .toList(),
    );
  }

}