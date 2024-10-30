import 'package:flutter/material.dart';
import 'package:mobicraft/flutter_generator/flutter_generator.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/text_form_field/attributes/text_field_attributes.dart';
import 'package:mobicraft/widgets/ui_element.dart';

class AppTextFormField extends BaseWidget{
  @override
  Widget generate(Map<String, dynamic> attributes) {
      return TextFormField(
        controller: attributes[TextFormFieldAttributeKeys.controller] as TextEditingController?,
        decoration: InputDecoration(
          labelText: attributes[TextFormFieldAttributeKeys.labelText] as String?,
          hintText: attributes[TextFormFieldAttributeKeys.hintText] as String?,
          helperText: attributes[TextFormFieldAttributeKeys.helperText] as String?,
          errorText: attributes[TextFormFieldAttributeKeys.errorText] as String?,
          prefixText: attributes[TextFormFieldAttributeKeys.prefixText] as String?,
          suffixText: attributes[TextFormFieldAttributeKeys.suffixText] as String?,
          icon: attributes[TextFormFieldAttributeKeys.icon] != null ? FlutterGenerator.generate(attributes[TextFormFieldAttributeKeys.icon] as UIElement) : null,
          prefixIcon: attributes[TextFormFieldAttributeKeys.prefixIcon] != null ? FlutterGenerator.generate(attributes[TextFormFieldAttributeKeys.prefixIcon] as UIElement) : null,
          suffixIcon: attributes[TextFormFieldAttributeKeys.suffixIcon] != null ? FlutterGenerator.generate(attributes[TextFormFieldAttributeKeys.suffixIcon] as UIElement) : null,
          suffix: attributes[TextFormFieldAttributeKeys.suffix] != null ? FlutterGenerator.generate(attributes[TextFormFieldAttributeKeys.suffix] as UIElement) : null,
          border: attributes[TextFormFieldAttributeKeys.border] as InputBorder? ?? const OutlineInputBorder(),
          focusedBorder: attributes[TextFormFieldAttributeKeys.focusedBorder] as InputBorder?,
          enabledBorder: attributes[TextFormFieldAttributeKeys.enabledBorder] as InputBorder?,
          disabledBorder: attributes[TextFormFieldAttributeKeys.disabledBorder] as InputBorder?,
          contentPadding: attributes[TextFormFieldAttributeKeys.contentPadding] as EdgeInsets?,
          fillColor: attributes[TextFormFieldAttributeKeys.fillColor] as Color?,
          filled: attributes[TextFormFieldAttributeKeys.filled] as bool? ?? false,
        ),
        textAlign: attributes[TextFormFieldAttributeKeys.textAlign] as TextAlign? ?? TextAlign.start,
        keyboardType: attributes[TextFormFieldAttributeKeys.keyboardType] as TextInputType? ?? TextInputType.text,
        obscureText: attributes[TextFormFieldAttributeKeys.obscureText] as bool? ?? false,
        maxLength: attributes[TextFormFieldAttributeKeys.maxLength] as int?,
        maxLines: attributes[TextFormFieldAttributeKeys.maxLines] as int?,
        minLines: attributes[TextFormFieldAttributeKeys.minLines] as int?,
        enabled: attributes[TextFormFieldAttributeKeys.enabled] as bool? ?? true,
        cursorColor: attributes[TextFormFieldAttributeKeys.cursorColor] as Color?,
        cursorWidth: attributes[TextFormFieldAttributeKeys.cursorWidth] as double? ?? 2.0,
        cursorHeight: attributes[TextFormFieldAttributeKeys.cursorHeight] as double?,
        showCursor: attributes[TextFormFieldAttributeKeys.showCursor] as bool?,
        readOnly: attributes[TextFormFieldAttributeKeys.readOnly] as bool? ?? false,
        expands: attributes[TextFormFieldAttributeKeys.expands] as bool? ?? false,
        validator: attributes[TextFormFieldAttributeKeys.validator] as String? Function(String?)?,
        onChanged: attributes[TextFormFieldAttributeKeys.onChanged] as void Function(String)?,
        onTap: attributes[TextFormFieldAttributeKeys.onTap] as void Function()?,
        onFieldSubmitted: attributes[TextFormFieldAttributeKeys.onFieldSubmitted] as void Function(String)?,
      );
  }

}