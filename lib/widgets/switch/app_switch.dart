import 'package:flutter/material.dart';
import 'package:mobicraft/widgets/base_widget/base_widget.dart';
import 'package:mobicraft/widgets/switch/attributes/switch_attributes.dart';

class AppSwitch extends BaseWidget {
  @override
  Widget generate(Map<String, dynamic> attributes) {
    return Switch(
      value: attributes[SwitchAttributeKeys.value] as bool? ?? false,
      onChanged: attributes[SwitchAttributeKeys.onChanged] as void Function(bool)?,
      activeColor: attributes[SwitchAttributeKeys.activeColor] as Color?,
      activeTrackColor: attributes[SwitchAttributeKeys.activeTrackColor] as Color?,
      inactiveThumbColor: attributes[SwitchAttributeKeys.inactiveThumbColor] as Color?,
      inactiveTrackColor: attributes[SwitchAttributeKeys.inactiveTrackColor] as Color?,
      materialTapTargetSize: attributes[SwitchAttributeKeys.materialTapTargetSize] as MaterialTapTargetSize?,
      focusColor: attributes[SwitchAttributeKeys.focusColor] as Color?,
      hoverColor: attributes[SwitchAttributeKeys.hoverColor] as Color?,
      splashRadius: attributes[SwitchAttributeKeys.splashRadius] as double?,
      autofocus: attributes[SwitchAttributeKeys.autofocus] as bool? ?? false,
    );
  }
}