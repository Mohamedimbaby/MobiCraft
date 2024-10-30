import 'dart:developer';
import 'dart:io';
import 'package:mobicraft/widgets/widget_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:permission_handler/permission_handler.dart'; // You need to add archive package to pubspec.yaml

class ProjectExporter {
  Future<void> exportProject(List<WidgetModel> widgets) async {
    // Get the directory to store the project files
    final directory = await getApplicationDocumentsDirectory();
    final projectDir = Directory('${directory.path}/client_project');

    // Create project directory
    if (!await projectDir.exists()) {
      await projectDir.create(recursive: true);
    }

    // Create lib directory and main.dart
    final libDir = Directory('${projectDir.path}/lib');
    await libDir.create();
    log("folder path is ${libDir.path}");

    final mainFile = File('${libDir.path}/main.dart');
    await mainFile.writeAsString(generateMainFile(widgets));

    // Create pubspec.yaml
    final pubspecFile = File('${projectDir.path}/pubspec.yaml');
    await pubspecFile.writeAsString(generatePubspecFile());

    // Create widgets directory
    final widgetsDir = Directory('${libDir.path}/widgets');
    await widgetsDir.create();

    // Generate widget files
    for (var widget in widgets) {
      final widgetFile = File('${widgetsDir.path}/${widget.type}Widget.dart');
      await widgetFile.writeAsString(generateWidgetFile(widget));
    }

    // Create a zip file
    // Request storage permission
    saveProjectAsZip(projectDir);
    // Notify user or provide download link
  }

  String generateMainFile(List<WidgetModel> widgets) {
    // Implementation for generating the main.dart file
    return '''
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            ${widgets.map((widget) => '${widget.type}Widget()').join(",\n")}
          ],
        ),
      ),
    );
  }
}
''';
  }

  String generatePubspecFile() {
    return '''
name: client_project
description: A new Flutter project
dependencies:
  flutter:
    sdk: flutter
''';
  }

  String generateWidgetFile(WidgetModel widgetModel) {
    // Create Dart code based on the WidgetModel
    String widgetType =
        widgetModel.type == "Button" ? "ElevatedButton" : "Text";
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

  Future<void> saveProjectAsZip(Directory projectDir) async {
    // Request storage permission
    var status = await Permission.storage.request();

    if (status.isGranted) {
      // Create an Archive
      final archive = Archive();

      // Read all files from the project directory
      for (var file in projectDir.listSync()) {
          
          log("file is : $file");
        if (file is File) {
          final bytes = await file.readAsBytes();
          // Add file to the archive
          archive.addFile(
              ArchiveFile(file.path.split('/').last, bytes.length, bytes));
        }
      }

      // Get the Downloads directory
      final downloadsDirectory = Directory('/storage/emulated/0/Download');

      // Create the zip file path
      final zipFile = File('${downloadsDirectory.path}/client_project.zip');

      // Create zip bytes from the archive
      final zipBytes = ZipEncoder().encode(archive);

      // Write the zip file to the Downloads directory
      await zipFile.writeAsBytes(zipBytes!);

      print('Zip file saved to ${zipFile.path}');
    } else {
      print('Permission denied');
    }
  }
}
