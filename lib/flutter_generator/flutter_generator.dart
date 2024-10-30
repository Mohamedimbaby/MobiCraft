import 'package:flutter/material.dart';
import 'package:mobicraft/widgets/button/app_button.dart';
import 'package:mobicraft/widgets/text/app_text.dart';
import 'package:mobicraft/widgets/ui_element.dart';

class FlutterGenerator {
  static Widget generate (UIElement uiElement){
    switch (uiElement.type){
      case  "button":
        return AppButton().generate(uiElement.properties ?? {});
      case "Text" :
        return AppText().generate(uiElement.properties ?? {});
      default :
        return const SizedBox();
    }
  }
}