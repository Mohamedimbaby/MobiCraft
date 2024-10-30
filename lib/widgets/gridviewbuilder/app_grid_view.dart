// app_gridview_builder.dart
import 'package:flutter/material.dart';
import 'package:mobicraft/flutter_generator/flutter_generator.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/gridviewbuilder/attributes/app_grid_view_attributes.dart';
import 'package:mobicraft/widgets/ui_element.dart';

class AppGridViewBuilder extends BaseWidget {
  @override
  Widget generate(Map<String, dynamic> attributes) {
    final itemBuilder = attributes[GridViewBuilderAttributeKeys.itemBuilder] as UIElement?;
    final itemCount = attributes[GridViewBuilderAttributeKeys.itemCount] as int?;
    final gridDelegate = attributes[GridViewBuilderAttributeKeys.gridDelegate] as String?;
    final scrollDirection = attributes[GridViewBuilderAttributeKeys.scrollDirection] as String?;
    final reverse = attributes[GridViewBuilderAttributeKeys.reverse] as bool? ?? false;
    final controller = attributes[GridViewBuilderAttributeKeys.controller] as ScrollController?;
    final primary = attributes[GridViewBuilderAttributeKeys.primary] as bool?;
    final physics = attributes[GridViewBuilderAttributeKeys.physics] as String?;
    final shrinkWrap = attributes[GridViewBuilderAttributeKeys.shrinkWrap] as bool? ?? false;
    final padding = attributes[GridViewBuilderAttributeKeys.padding] as EdgeInsets?;
    final cacheExtent = attributes[GridViewBuilderAttributeKeys.cacheExtent] as double?;
    final semanticChildCount = attributes[GridViewBuilderAttributeKeys.semanticChildCount] as int?;
    final clipBehavior = attributes[GridViewBuilderAttributeKeys.clipBehavior] as String?;

    return GridView.builder(
      gridDelegate: _parseGridDelegate(gridDelegate),
      itemBuilder: (context, index) => FlutterGenerator.generate(itemBuilder!),
      itemCount: itemCount,
      scrollDirection: _parseAxis(scrollDirection),
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: _parseScrollPhysics(physics),
      shrinkWrap: shrinkWrap,
      padding: padding,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount,
      clipBehavior: _parseClipBehavior(clipBehavior),
    );
  }

  SliverGridDelegate _parseGridDelegate(String? delegate) {
    switch (delegate) {
      case 'fixedCrossAxisCount':
        return const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2);
      case 'maxCrossAxisExtent':
        return const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200.0);
      default:
        return const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2);
    }
  }

  Axis _parseAxis(String? axis) {
    switch (axis) {
      case 'horizontal':
        return Axis.horizontal;
      case 'vertical':
      default:
        return Axis.vertical;
    }
  }

  ScrollPhysics? _parseScrollPhysics(String? physics) {
    switch (physics) {
      case 'BouncingScrollPhysics':
        return const BouncingScrollPhysics();
      case 'ClampingScrollPhysics':
        return const ClampingScrollPhysics();
      case 'NeverScrollableScrollPhysics':
        return const NeverScrollableScrollPhysics();
      case 'AlwaysScrollableScrollPhysics':
        return const AlwaysScrollableScrollPhysics();
      default:
        return null;
    }
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
