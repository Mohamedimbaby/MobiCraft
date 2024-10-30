import 'package:flutter/material.dart';
import 'package:mobicraft/flutter_generator/flutter_generator.dart';
import 'package:mobicraft/widgets/ListViewBuilder/attributes/list_view_builder_attributes.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/ui_element.dart';

class AppListViewBuilder extends BaseWidget {
  @override
  Widget generate(Map<String, dynamic> attributes) {
    final itemBuilder = attributes[ListViewBuilderAttributeKeys.itemBuilder] as UIElement?;
    final itemCount = attributes[ListViewBuilderAttributeKeys.itemCount] as int?;
    final scrollDirection = attributes[ListViewBuilderAttributeKeys.scrollDirection] as String?;
    final reverse = attributes[ListViewBuilderAttributeKeys.reverse] as bool? ?? false;
    final controller = attributes[ListViewBuilderAttributeKeys.controller] as ScrollController?;
    final primary = attributes[ListViewBuilderAttributeKeys.primary] as bool?;
    final physics = attributes[ListViewBuilderAttributeKeys.physics] as String?;
    final shrinkWrap = attributes[ListViewBuilderAttributeKeys.shrinkWrap] as bool? ?? false;
    final padding = attributes[ListViewBuilderAttributeKeys.padding] as EdgeInsets?;
    final itemExtent = attributes[ListViewBuilderAttributeKeys.itemExtent] as double?;
    final cacheExtent = attributes[ListViewBuilderAttributeKeys.cacheExtent] as double?;
    final semanticChildCount = attributes[ListViewBuilderAttributeKeys.semanticChildCount] as int?;
    final addAutomaticKeepAlives = attributes[ListViewBuilderAttributeKeys.addAutomaticKeepAlives] as bool? ?? true;
    final addRepaintBoundaries = attributes[ListViewBuilderAttributeKeys.addRepaintBoundaries] as bool? ?? true;
    final addSemanticIndexes = attributes[ListViewBuilderAttributeKeys.addSemanticIndexes] as bool? ?? true;
    final clipBehavior = attributes[ListViewBuilderAttributeKeys.clipBehavior] as String?;

    return ListView.builder(
      itemBuilder: (context, index) => FlutterGenerator.generate(itemBuilder!),
      itemCount: itemCount,
      scrollDirection: _parseAxis(scrollDirection),
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: _parseScrollPhysics(physics),
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemExtent: itemExtent,
      cacheExtent: cacheExtent,
      semanticChildCount: semanticChildCount,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      clipBehavior: _parseClipBehavior(clipBehavior),
    );
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
