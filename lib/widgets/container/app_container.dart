import 'package:flutter/material.dart';
import 'package:mobicraft/flutter_generator/flutter_generator.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/container/attributes/app_container_attributes.dart';
import 'package:mobicraft/widgets/ui_element.dart';

class AppContainer extends BaseWidget {
  @override
  Widget generate(Map<String, dynamic> attributes) {
    return Container(
      width: attributes[ContainerAttributeKeys.width] as double?,
      height: attributes[ContainerAttributeKeys.height] as double?,
      color: attributes[ContainerAttributeKeys.color] as Color?,
      padding: attributes[ContainerAttributeKeys.padding] as EdgeInsets?,
      margin: attributes[ContainerAttributeKeys.margin] as EdgeInsets?,
      alignment: attributes[ContainerAttributeKeys.alignment] as Alignment?,
      decoration: attributes[ContainerAttributeKeys.decoration] as BoxDecoration?,
      foregroundDecoration: attributes[ContainerAttributeKeys.foregroundDecoration] as BoxDecoration?,
      constraints: attributes[ContainerAttributeKeys.constraints] as BoxConstraints?,
      transform: attributes[ContainerAttributeKeys.transform] as Matrix4?,
      transformAlignment: attributes[ContainerAttributeKeys.transformAlignment] as Alignment?,
      clipBehavior: attributes[ContainerAttributeKeys.clipBehavior] as Clip? ?? Clip.none,
      child: attributes[ContainerAttributeKeys.child]!=null ? FlutterGenerator.generate(attributes[ContainerAttributeKeys.child] as UIElement) : const SizedBox(),
    );
  }
  
}