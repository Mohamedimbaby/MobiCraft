import 'package:flutter/material.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/icon/attributes/icon_attributes.dart';

class AppIcon extends BaseWidget{
  @override
  Widget generate(Map<String, dynamic> attributes) {
    return Icon(
      attributes[IconAttributeKeys.iconData] as IconData? ?? Icons.info, // Default to Icons.info if not provided
      size: attributes[IconAttributeKeys.size] as double?,
      color: attributes[IconAttributeKeys.color] as Color?,
      semanticLabel: attributes[IconAttributeKeys.semanticLabel] as String?,
      textDirection: attributes[IconAttributeKeys.textDirection] as TextDirection?,
    );
  }

}