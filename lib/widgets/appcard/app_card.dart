// app_card_widget.dart
import 'package:flutter/material.dart';
import 'package:mobicraft/flutter_generator/flutter_generator.dart';
import 'package:mobicraft/widgets/appcard/attributes/app_card_attributes.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/ui_element.dart';

class AppCardWidget extends BaseWidget {
  @override
  Widget generate(Map<String, dynamic> attributes) {
    final child = attributes[CardAttributeKeys.child] as UIElement?;
    final color = attributes[CardAttributeKeys.color] as Color?;
    final shadowColor = attributes[CardAttributeKeys.shadowColor] as Color?;
    final elevation = attributes[CardAttributeKeys.elevation] as double?;
    final shape = attributes[CardAttributeKeys.shape] as ShapeBorder?;
    final margin = attributes[CardAttributeKeys.margin] as EdgeInsets?;
    final surfaceTintColor = attributes[CardAttributeKeys.surfaceTintColor] as Color?;
    final clipBehavior = attributes[CardAttributeKeys.clipBehavior] as String?;
    final semanticContainer = attributes[CardAttributeKeys.semanticContainer] as bool? ?? true;
    final borderOnForeground = attributes[CardAttributeKeys.borderOnForeground] as bool? ?? true;

    return Card(
      color: color,
      shadowColor: shadowColor,
      elevation: elevation,
      shape: shape,
      margin: margin,
      surfaceTintColor:surfaceTintColor,
      clipBehavior: _parseClipBehavior(clipBehavior),
      semanticContainer: semanticContainer,
      borderOnForeground: borderOnForeground,
      child: child != null ? FlutterGenerator.generate(child) : null,
    );
  }

  Clip _parseClipBehavior(String? clipBehavior) {
    switch (clipBehavior) {
      case 'antiAlias':
        return Clip.antiAlias;
      case 'hardEdge':
        return Clip.hardEdge;
      case 'antiAliasWithSaveLayer':
        return Clip.antiAliasWithSaveLayer;
      case 'none':
      default:
        return Clip.none;
    }
  }
}
