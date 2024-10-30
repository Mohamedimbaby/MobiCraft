import 'package:flutter/material.dart';
import 'package:mobicraft/flutter_generator/flutter_generator.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/gridView/attributes/grid_view_attributes.dart';
import 'package:mobicraft/widgets/ui_element.dart';

class AppGridView extends BaseWidget {
  @override
  Widget generate(Map<String, dynamic> attributes) {
    return GridView(
      padding: attributes[GridViewAttributeKeys.padding] as EdgeInsets?,
      gridDelegate: attributes[GridViewAttributeKeys.gridDelegate] as SliverGridDelegate,
      scrollDirection: attributes[GridViewAttributeKeys.scrollDirection] as Axis? ?? Axis.vertical,
      reverse: attributes[GridViewAttributeKeys.reverse] as bool? ?? false,
      children: (attributes[GridViewAttributeKeys.children] as List<UIElement>)
          .map((childElement) => FlutterGenerator.generate(childElement))
          .toList(),
    );
  }

}