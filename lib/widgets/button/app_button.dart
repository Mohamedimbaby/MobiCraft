import 'package:flutter/material.dart';
import 'package:mobicraft/flutter_generator/flutter_generator.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/button/attributes/button_attributes_keys.dart';
import 'package:mobicraft/widgets/ui_element.dart';

class AppButton extends BaseWidget{
  @override
  Widget generate(Map<String, dynamic> attributes ) {
    final text = attributes[ButtonAttributes.text] ?? 'Button';
    final color = attributes[ButtonAttributes.color] ?? Colors.blue;
    final width = attributes[ButtonAttributes.width] ?? 100.0;
    final height = attributes[ButtonAttributes.height] ?? 40.0;
    // Text styling
    final textColor = attributes[ButtonAttributes.textColor] ?? Colors.white;
    final fontSize = attributes[ButtonAttributes.fontSize] ?? 16.0;
    final fontWeight = attributes[ButtonAttributes.fontWeight] ?? FontWeight.normal;
    final fontStyle = attributes[ButtonAttributes.fontStyle] ?? FontStyle.normal;

    // Button styling
    final backgroundColor = attributes[ButtonAttributes.backgroundColor] ?? color;
    final elevation = attributes[ButtonAttributes.elevation] ?? 2.0;
    final padding = attributes[ButtonAttributes.padding] ?? const EdgeInsets.symmetric(horizontal: 16.0);
    final borderRadius = attributes[ButtonAttributes.borderRadius] ?? 8.0;
    final shadowColor = attributes[ButtonAttributes.shadowColor] ?? Colors.black;

    // Shape and alignment
    final alignment = attributes[ButtonAttributes.alignment] ?? Alignment.center;
    final minimumSize = attributes[ButtonAttributes.minimumSize] ?? const Size(80, 40);
    final maximumSize = attributes[ButtonAttributes.maximumSize] ?? const Size(double.infinity, 56);

    // Icon and child
    final icon = attributes[ButtonAttributes.icon] as UIElement?;
    final child = attributes[ButtonAttributes.child] as UIElement?;

    // Create button with or without an icon
    return SizedBox(
      width: width,
      height: height,
      child: icon != null
          ? ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: elevation,
          padding: padding,
          shadowColor: shadowColor,
          minimumSize: minimumSize,
          maximumSize: maximumSize,
          alignment: alignment,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: attributes[ButtonAttributes.onPressed] ?? () {},
        icon: FlutterGenerator.generate(icon),
        label: child != null ? FlutterGenerator.generate(child) :
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
                fontStyle: fontStyle,
              ),
            ),
      )
          : ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: elevation,
          padding: padding,
          shadowColor: shadowColor,
          minimumSize: minimumSize,
          maximumSize: maximumSize,
          alignment: alignment,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: attributes[ButtonAttributes.onPressed] ?? () {},
        child: child != null ? FlutterGenerator.generate(child) :
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
                fontStyle: fontStyle,
              ),
            ),
      ),
    );
  }

}