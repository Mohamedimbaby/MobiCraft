import 'package:flutter/material.dart';
import 'package:mobicraft/flutter_generator/flutter_generator.dart';
import 'package:mobicraft/widgets/appbar/attributes/app_bar_attributes.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/ui_element.dart';

class AppBarWidget extends BaseWidget {
  @override
  Widget generate(Map<String, dynamic> attributes) {
    final title=attributes[AppBarAttributeKeys.title] as UIElement?;
    final leading=attributes[AppBarAttributeKeys.leading] as UIElement?;
    final actions=(attributes[AppBarAttributeKeys.actions] as List<UIElement>?);
    final backgroundColor=  attributes[AppBarAttributeKeys.backgroundColor] as Color?;
    final centerTitle=attributes [AppBarAttributeKeys.centerTitle] as bool?;
    final foregroundColor= attributes[AppBarAttributeKeys.foregroundColor] as Color?;
    final elevation= attributes[AppBarAttributeKeys.elevation] as double?;
    final bottom= attributes[AppBarAttributeKeys.bottom] as PreferredSizeWidget?;
    final shape= attributes[AppBarAttributeKeys.shape] as ShapeBorder?;
    final toolbarHeight= attributes[AppBarAttributeKeys.toolbarHeight] as double?;

    return AppBar(
      title:title!=null? FlutterGenerator.generate(title):null,
      leading:leading!=null? FlutterGenerator.generate(leading) :null,
      actions:actions?.map(FlutterGenerator.generate).toList(),
      centerTitle: centerTitle,
      backgroundColor:backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      bottom: bottom,
      shape: shape,
      toolbarHeight: toolbarHeight,
    );
  }
}
