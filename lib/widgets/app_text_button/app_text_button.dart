// app_text_button_widget.dart
import 'package:flutter/material.dart';
import 'package:mobicraft/flutter_generator/flutter_generator.dart';
import 'package:mobicraft/widgets/app_text_button/attributes/text_attributes.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/ui_element.dart';

class AppTextButtonWidget extends BaseWidget {
  @override
  Widget generate(Map<String, dynamic> attributes) {
    final child = attributes[TextButtonAttributeKeys.child] as UIElement?;
    final onPressed = attributes[TextButtonAttributeKeys.onPressed] as VoidCallback?;
    final onLongPress = attributes[TextButtonAttributeKeys.onLongPress] as VoidCallback?;
    final style = attributes[TextButtonAttributeKeys.style] as ButtonStyle?;
    final focusNode = attributes[TextButtonAttributeKeys.focusNode] as FocusNode?;
    final autofocus = attributes[TextButtonAttributeKeys.autofocus] as bool? ?? false;
    final clipBehavior = attributes[TextButtonAttributeKeys.clipBehavior] as String?;

    return TextButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: _parseClipBehavior(clipBehavior),
      child: child != null ? FlutterGenerator.generate(child) : const SizedBox.shrink(),
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
