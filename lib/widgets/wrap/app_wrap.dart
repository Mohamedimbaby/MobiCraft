import 'package:flutter/material.dart';
import 'package:mobicraft/flutter_generator/flutter_generator.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/ui_element.dart';
import 'package:mobicraft/widgets/wrap/attributes/wrap_attributes.dart';

class AppWrap extends BaseWidget{
  @override
  Widget generate(Map<String, dynamic> attributes) {
   return Wrap(
     alignment: attributes[WrapAttributeKeys.alignment] as WrapAlignment? ?? WrapAlignment.start,
     spacing: attributes[WrapAttributeKeys.spacing] as double? ?? 0.0,
     runSpacing: attributes[WrapAttributeKeys.runSpacing] as double? ?? 0.0,
     direction: attributes[WrapAttributeKeys.direction] as Axis? ?? Axis.horizontal,
     crossAxisAlignment: attributes[WrapAttributeKeys.crossAxisAlignment] as WrapCrossAlignment? ?? WrapCrossAlignment.start,
     children: (attributes[WrapAttributeKeys.children] as List<UIElement>)
         .map((childElement) => FlutterGenerator.generate(childElement))
         .toList(),
   );
  }
}