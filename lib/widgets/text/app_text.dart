import 'package:flutter/material.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/text/attributes/text_attributes.dart';

class AppText extends BaseWidget {
  @override
  Widget generate(Map<String, dynamic> attributes) {
    return Text(
      attributes[TextAttributeKeys.text] ?? '',
      style: TextStyle(
        fontSize: attributes[TextAttributeKeys.fontSize] as double? ?? 14.0,
        color: attributes[TextAttributeKeys.color] as Color? ?? Colors.black,
        fontWeight: attributes[TextAttributeKeys.fontWeight] as FontWeight? ?? FontWeight.normal,
        fontStyle: attributes[TextAttributeKeys.fontStyle] as FontStyle? ?? FontStyle.normal,
        letterSpacing: attributes[TextAttributeKeys.letterSpacing] as double? ?? 0.0,
        wordSpacing: attributes[TextAttributeKeys.wordSpacing] as double? ?? 0.0,
      ),
      textAlign: attributes[TextAttributeKeys.textAlign] as TextAlign? ?? TextAlign.start,
      textDirection: attributes[TextAttributeKeys.textDirection] as TextDirection? ?? TextDirection.ltr,
      overflow: attributes[TextAttributeKeys.overflow] as TextOverflow? ?? TextOverflow.clip,
      maxLines: attributes[TextAttributeKeys.maxLines] as int? ?? 1,
    );
  }

}