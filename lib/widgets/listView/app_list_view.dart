import 'package:flutter/material.dart';
import 'package:mobicraft/flutter_generator/flutter_generator.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/listView/attributes/list_view_attributes.dart';
import 'package:mobicraft/widgets/ui_element.dart';

class AppListView extends BaseWidget {
  @override
  Widget generate(Map<String, dynamic> attributes) {
   return ListView(
     padding: attributes[ListViewAttributeKeys.padding] as EdgeInsets?,
     itemExtent: attributes[ListViewAttributeKeys.itemExtent] as double?,
     scrollDirection: attributes[ListViewAttributeKeys.scrollDirection] as Axis? ?? Axis.vertical,
     reverse: attributes[ListViewAttributeKeys.reverse] as bool? ?? false,
     controller: attributes[ListViewAttributeKeys.controller] as ScrollController?,
     children: (attributes[ListViewAttributeKeys.children] as List<UIElement>)
         .map((childElement) => FlutterGenerator.generate(childElement))
         .toList(),
   );
  }

}