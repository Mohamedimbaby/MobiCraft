import 'package:flutter/material.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/checkbox/attributes/checkbox_attributes.dart';

class AppCheckbox extends BaseWidget {
  @override
  Widget generate(Map<String, dynamic> attributes) {
    return Checkbox(
      value: attributes[CheckboxAttributeKeys.value] as bool? ?? false,
      onChanged: attributes[CheckboxAttributeKeys.onChanged] as void Function(bool?)?,
      activeColor: attributes[CheckboxAttributeKeys.activeColor] as Color?,
      checkColor: attributes[CheckboxAttributeKeys.checkColor] as Color?,
      focusColor: attributes[CheckboxAttributeKeys.focusColor] as Color?,
      hoverColor: attributes[CheckboxAttributeKeys.hoverColor] as Color?,
      autofocus: attributes[CheckboxAttributeKeys.autofocus] as bool? ?? false,
      shape: attributes[CheckboxAttributeKeys.shape] as OutlinedBorder?,
      side: attributes[CheckboxAttributeKeys.side] as BorderSide?,
      tristate: attributes[CheckboxAttributeKeys.tristate] as bool? ?? false,
    );
  }
}