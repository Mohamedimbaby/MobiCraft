
import '../widgets/widget_model.dart';

class ExportService {
  String generateDartCode(WidgetModel widgetModel) {
    String widgetType = widgetModel.type == "Button" ? "ElevatedButton" : "Text";
    String positionCode = widgetModel.position != null
        ? "Positioned(left: ${widgetModel.position!.dx}, top: ${widgetModel.position!.dy})"
        : "";

    return '''
import 'package:flutter/material.dart';

class ${widgetModel.type}Widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return $positionCode(
      child: $widgetType(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(${widgetModel.backgroundColor}),
        ),
        child: Text(
          '${widgetModel.text}',
          style: TextStyle(
            fontSize: ${widgetModel.fontSize},
            color: ${widgetModel.textColor},
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}
''';
  }
}
