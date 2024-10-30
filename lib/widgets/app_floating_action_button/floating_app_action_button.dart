// app_floating_action_button_widget.dart
import 'package:flutter/material.dart';
import 'package:mobicraft/flutter_generator/flutter_generator.dart';
import 'package:mobicraft/widgets/app_floating_action_button/attributes/floating_action_button_attributes.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/ui_element.dart';

class AppFloatingActionButtonWidget extends BaseWidget {
  @override
  Widget generate(Map<String, dynamic> attributes) {
    final child = attributes[FloatingActionButtonAttributeKeys.child] as UIElement?;
    final onPressed = attributes[FloatingActionButtonAttributeKeys.onPressed] as VoidCallback?;
    final tooltip = attributes[FloatingActionButtonAttributeKeys.tooltip] as String?;
    final backgroundColor = attributes[FloatingActionButtonAttributeKeys.backgroundColor] as Color?;
    final foregroundColor = attributes[FloatingActionButtonAttributeKeys.foregroundColor] as Color?;
    final focusColor = attributes[FloatingActionButtonAttributeKeys.focusColor] as Color?;
    final hoverColor = attributes[FloatingActionButtonAttributeKeys.hoverColor] as Color?;
    final splashColor = attributes[FloatingActionButtonAttributeKeys.splashColor] as Color?;
    final elevation = attributes[FloatingActionButtonAttributeKeys.elevation] as double?;
    final focusElevation = attributes[FloatingActionButtonAttributeKeys.focusElevation] as double?;
    final hoverElevation = attributes[FloatingActionButtonAttributeKeys.hoverElevation] as double?;
    final disabledElevation = attributes[FloatingActionButtonAttributeKeys.disabledElevation] as double?;
    final highlightElevation = attributes[FloatingActionButtonAttributeKeys.highlightElevation] as double?;
    final heroTag = attributes[FloatingActionButtonAttributeKeys.heroTag] as Object?;
    final clipBehavior = attributes[FloatingActionButtonAttributeKeys.clipBehavior] as String?;
    final isExtended = attributes[FloatingActionButtonAttributeKeys.isExtended] as bool? ?? false;
    final materialTapTargetSize = attributes[FloatingActionButtonAttributeKeys.materialTapTargetSize] as String?;
    final shape = attributes[FloatingActionButtonAttributeKeys.shape] as ShapeBorder?;
    final enableFeedback = attributes[FloatingActionButtonAttributeKeys.enableFeedback] as bool? ?? true;

    return FloatingActionButton(
      onPressed: onPressed,
    
      tooltip: tooltip,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      splashColor: splashColor,
      elevation: elevation,
      focusElevation: focusElevation,
      hoverElevation: hoverElevation,
      disabledElevation: disabledElevation,
      highlightElevation: highlightElevation,
      heroTag: heroTag,
      clipBehavior: _parseClipBehavior(clipBehavior),
      isExtended: isExtended,
      materialTapTargetSize: _parseMaterialTapTargetSize(materialTapTargetSize),
      shape: shape,
      enableFeedback: enableFeedback,
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

  MaterialTapTargetSize? _parseMaterialTapTargetSize(String? size) {
    switch (size) {
      case 'padded':
        return MaterialTapTargetSize.padded;
      case 'shrinkWrap':
        return MaterialTapTargetSize.shrinkWrap;
      default:
        return null;
    }
  }
}
