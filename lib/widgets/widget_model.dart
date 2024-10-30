import 'package:flutter/material.dart';
class WidgetModel {
  final String? id;
  final String type; // e.g., "Button", "Text"
  final String text;
  final Color? backgroundColor;
  final double? fontSize;
  final double borderRadius;
  final WidgetModel?
      child; // This allows nested widgets, e.g., a button having a text as a child
  final List<WidgetModel>?
      children; // For widgets that can have multiple children, like a Column or Stack

  final Color? textColor;
  final Color? borderColor;
  final Offset? position;

  final BoxDecoration? boxDecoration;

  // Add other properties as needed

  WidgetModel copyWith({
    String? id,
    String? type, // e.g., "Button", "Text"
    String? text,
    Color? backgroundColor,
    double? fontSize,
    double? borderRadius,
    Offset? position,
    WidgetModel?
        child, // This allows nested widgets, e.g., a button having a text as a child
    List<WidgetModel>?
        children, // For widgets that can have multiple children, like a Column or Stack

    Color? textColor,
    Color? borderColor,
    BoxDecoration? boxDecoration,
  }) {
    return WidgetModel(
      id: id ?? this.id,
      type: type ?? this.type,
      text: text ?? this.text,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontSize: fontSize ?? this.fontSize,
      position: position ?? this.position,
      child: child ?? this.child,
      children: children ?? this.children,
      borderRadius: borderRadius ?? this.borderRadius,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      boxDecoration: boxDecoration ?? this.boxDecoration,
    );
  }

  const WidgetModel({
    this.id,
    required this.type,
    this.boxDecoration,
    required this.text,
    this.backgroundColor,
    this.fontSize = 12,
    this.borderColor,
    this.children,
    this.textColor,
    this.position,
    this.borderRadius = 0.0,
    this.child,
  });

  // Example serialization for Firestore or local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'text': text,
      'position': position,
      'backgroundColor': backgroundColor,
      'fontSize': fontSize,
      'child': child?.toJson(),
      'children': children?.map((c) => c.toJson()).toList(),
    };
  }

  static WidgetModel fromJson(Map<String, dynamic> json) {
    return WidgetModel(
      id: json['id'],
      type: json['type'],
      text: json['text'],
      position: json['position'],
      backgroundColor: Color(json['backgroundColor']),
      fontSize: json['fontSize'],
      child: json['child'] != null ? WidgetModel.fromJson(json['child']) : null,
      children: json['children'] != null
          ? (json['children'] as List)
              .map((childJson) => WidgetModel.fromJson(childJson))
              .toList()
          : null,
    );
  }
}
