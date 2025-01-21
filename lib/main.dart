// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppBuilderState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter App Builder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AppBuilderScreen(),
    );
  }
}

class AppBuilderScreen extends StatelessWidget {
  const AppBuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppBuilderState>(
      builder: (context, state, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Flutter App Builder'),
            actions: [
              IconButton(
                icon: const Icon(Icons.palette),
                onPressed: () => _showCanvasColorPicker(context),
              ),
              IconButton(
                icon: const Icon(Icons.code),
                tooltip: 'Export Code',
                onPressed: () => _showExportDialog(context),
              ),
            ],
          ),
          drawer: const WidgetDrawer(),
          body: Container(
            color: state.canvasColor,
            child: const BuilderCanvas(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.read<AppBuilderState>().addNewScreen();
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showCanvasColorPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CanvasColorPicker(),
    );
  }

  void _showExportDialog(BuildContext context) {
    final state = context.read<AppBuilderState>();
    final code = _generateFlutterCode(state.currentScreenWidgets);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 800,
          height: 600,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Text(
                    'Generated Flutter Code',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy to Clipboard',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: code));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Code copied to clipboard')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: SelectableText(code),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _generateFlutterCode(List<BuilderWidget> widgets) {
    final buffer = StringBuffer();
    buffer.writeln('import \'package:flutter/material.dart\';');
    buffer.writeln();
    buffer.writeln('class GeneratedScreen extends StatelessWidget {');
    buffer.writeln('  const GeneratedScreen({super.key});');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln('  Widget build(BuildContext context) {');
    buffer.writeln('    return Scaffold(');
    buffer.writeln('      body: Stack(');
    buffer.writeln('        children: [');

    for (final widget in widgets) {
      buffer.writeln('          Positioned(');
      buffer.writeln('            left: ${widget.position.dx},');
      buffer.writeln('            top: ${widget.position.dy},');
      buffer.writeln('            child: ${_generateWidgetCode(widget)},');
      buffer.writeln('          ),');
    }

    buffer.writeln('        ],');
    buffer.writeln('      ),');
    buffer.writeln('    );');
    buffer.writeln('  }');
    buffer.writeln('}');

    return buffer.toString();
  }

  String _generateWidgetCode(BuilderWidget widget) {
    switch (widget.type) {
      case 'Text':
        final text = widget.properties['text'] ?? 'Text';
        final color = _parseColor(widget.properties['color']) ?? Colors.black;
        final fontSize = widget.properties['fontSize']?.toDouble() ?? 14.0;

        return '''
          Text(
            '$text',
            style: TextStyle(
              color: Color(0x${color.value.toRadixString(16)}),
              fontSize: $fontSize,
            ),
          )
        ''';

      case 'Button':
        final buttonStyle = widget.properties['buttonStyle'] ?? 'elevated';
        final iconData = widget.properties['icon'];
        final iconPosition = widget.properties['iconPosition'] ?? 'start';
        final text = widget.properties['text'] ?? 'Button';
        final color = _parseColor(widget.properties['color']) ?? Colors.blue;
        final textColor =
            _parseColor(widget.properties['textColor']) ?? Colors.white;
        final width = widget.properties['width']?.toDouble() ?? 120.0;
        final height = widget.properties['height']?.toDouble() ?? 40.0;
        final borderRadius =
            widget.properties['borderRadius']?.toDouble() ?? 4.0;

        final buttonCode = StringBuffer();
        buttonCode.write('SizedBox(');
        buttonCode.write('width: $width, height: $height,');
        buttonCode.write('child: ');

        switch (buttonStyle) {
          case 'outlined':
            buttonCode.write('OutlinedButton(');
            break;
          case 'text':
            buttonCode.write('TextButton(');
            break;
          default:
            buttonCode.write('ElevatedButton(');
        }

        buttonCode.write('onPressed: () {},');
        buttonCode.write('style: ${buttonStyle}Button.styleFrom(');
        if (buttonStyle == 'elevated') {
          buttonCode.write(
              'backgroundColor: Color(0x${color.value.toRadixString(16)}),');
        }
        buttonCode.write(
            'foregroundColor: Color(0x${textColor.value.toRadixString(16)}),');
        if (buttonStyle == 'outlined') {
          buttonCode.write(
              'side: BorderSide(color: Color(0x${color.value.toRadixString(16)})),');
        }
        buttonCode.write('shape: RoundedRectangleBorder(');
        buttonCode.write('borderRadius: BorderRadius.circular($borderRadius),');
        buttonCode.write('),');
        buttonCode.write('),');

        if (iconData != null && iconData != 'none') {
          buttonCode.write('child: Row(');
          buttonCode.write('mainAxisSize: MainAxisSize.min,');
          buttonCode.write('mainAxisAlignment: MainAxisAlignment.center,');
          buttonCode.write('children: [');
          if (iconPosition == 'start') {
            buttonCode.write('Icon(Icons.$iconData),');
            buttonCode.write('const SizedBox(width: 8),');
            buttonCode.write('Text(\'$text\'),');
          } else {
            buttonCode.write('Text(\'$text\'),');
            buttonCode.write('const SizedBox(width: 8),');
            buttonCode.write('Icon(Icons.$iconData),');
          }
          buttonCode.write(']),');
        } else {
          buttonCode.write('child: Text(\'$text\'),');
        }

        buttonCode.write(')');
        return buttonCode.toString();

      case 'TextField':
        final width = widget.properties['width'] ?? 200.0;
        final hint = widget.properties['hint'] ?? 'Enter text';
        final textColor =
            _parseColor(widget.properties['textColor']) ?? Colors.black;
        final backgroundColor =
            _parseColor(widget.properties['backgroundColor']) ?? Colors.white;
        final borderStyle = widget.properties['borderStyle'] ?? 'outline';
        final borderColor =
            _parseColor(widget.properties['borderColor']) ?? Colors.grey;
        final borderRadius =
            widget.properties['borderRadius']?.toDouble() ?? 4.0;

        return '''
          SizedBox(
            width: $width,
            child: TextField(
              decoration: InputDecoration(
                hintText: '$hint',
                filled: true,
                fillColor: Color(0x${backgroundColor.value.toRadixString(16)}),
                border: ${_getBorderCode(borderStyle, borderColor, borderRadius)},
                enabledBorder: ${_getBorderCode(borderStyle, borderColor, borderRadius)},
                focusedBorder: ${_getBorderCode(borderStyle, borderColor, borderRadius)},
              ),
              style: TextStyle(
                color: Color(0x${textColor.value.toRadixString(16)}),
              ),
            ),
          )
        ''';

      case 'Row':
      case 'Column':
        final isRow = widget.type == 'Row';
        final mainAxisAlignment =
            _getMainAxisAlignmentCode(widget.properties['mainAxisAlignment']);
        final crossAxisAlignment =
            _getCrossAxisAlignmentCode(widget.properties['crossAxisAlignment']);
        final size = widget.properties['size']?.toDouble() ?? 100.0;
        final padding = widget.properties['padding']?.toDouble() ?? 8.0;
        final spacing = widget.properties['spacing']?.toDouble() ?? 8.0;
        final backgroundColor =
            _parseColor(widget.properties['backgroundColor']) ??
                Colors.transparent;

        return '''
          Container(
            width: ${isRow ? 'null' : size},
            height: ${isRow ? size : 'null'},
            padding: EdgeInsets.all($padding),
            decoration: BoxDecoration(
              color: Color(0x${backgroundColor.value.toRadixString(16)}),
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
            ),
            child: ${widget.type}(
              mainAxisAlignment: $mainAxisAlignment,
              crossAxisAlignment: $crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all($spacing),
                  child: Text('${widget.type} Item'),
                ),
              ],
            ),
          )
        ''';

      case 'Icon':
        final iconData = IconData(
          widget.properties['iconData'] ?? Icons.star.codePoint,
          fontFamily: 'MaterialIcons',
        );
        final color = _parseColor(widget.properties['color']) ?? Colors.black;
        final size = widget.properties['size']?.toDouble() ?? 24.0;
        final rotation = widget.properties['rotation']?.toDouble() ?? 0.0;

        return '''
          Transform.rotate(
            angle: $rotation * 3.14159 / 180,
            child: Icon(
              $iconData,
              size: $size,
              color: Color(0x${color.value.toRadixString(16)}),
            ),
          )
        ''';

      case 'Image':
        final width = widget.properties['width'] ?? 150.0;
        final height = widget.properties['height'] ?? 150.0;

        return '''
          Container(
            width: $width,
            height: $height,
            color: Colors.grey[300],
            child: Icon(Icons.image, size: 50),
          )
        ''';

      case 'Card':
        final width = widget.properties['width'] ?? 200.0;
        final height = widget.properties['height'] ?? 100.0;
        final color = _parseColor(widget.properties['color']) ?? Colors.white;

        return '''
          Card(
            child: Container(
              width: $width,
              height: $height,
              padding: const EdgeInsets.all(16),
              color: Color(0x${color.value.toRadixString(16)}),
              child: const Center(child: Text('Card Content')),
            ),
          )
        ''';

      case 'Container':
        final backgroundColor =
            _parseColor(widget.properties['backgroundColor']) ?? Colors.blue;
        final width = widget.properties['width']?.toDouble() ?? 100.0;
        final height = widget.properties['height']?.toDouble() ?? 100.0;
        final borderRadius =
            widget.properties['borderRadius']?.toDouble() ?? 0.0;
        final borderWidth = widget.properties['borderWidth']?.toDouble() ?? 1.0;
        final borderColor =
            _parseColor(widget.properties['borderColor']) ?? Colors.grey;

        return '''
          Container(
            width: $width,
            height: $height,
            decoration: BoxDecoration(
              color: Color(0x${backgroundColor.value.toRadixString(16)}),
              borderRadius: BorderRadius.circular($borderRadius),
              border: Border.all(
                color: Color(0x${borderColor.value.toRadixString(16)}),
                width: $borderWidth,
              ),
            ),
          )
        ''';

      case 'ListView':
        final scrollDirection =
            widget.properties['scrollDirection'] ?? 'vertical';
        final padding = widget.properties['padding']?.toDouble() ?? 8.0;
        final spacing = widget.properties['spacing']?.toDouble() ?? 8.0;
        final backgroundColor =
            _parseColor(widget.properties['backgroundColor']) ??
                Colors.transparent;
        final width = widget.properties['width']?.toDouble() ?? 200.0;
        final height = widget.properties['height']?.toDouble() ?? 300.0;

        return '''
          Container(
            width: $width,
            height: $height,
            decoration: BoxDecoration(
              color: Color(0x${backgroundColor.value.toRadixString(16)}),
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
            ),
            child: ListView(
              scrollDirection: $scrollDirection == 'horizontal' ? Axis.horizontal : Axis.vertical,
              padding: EdgeInsets.all($padding),
              children: [
                Container(
                  padding: EdgeInsets.all($spacing),
                  child: Text('ListView Item'),
                ),
              ],
            ),
          )
        ''';

      default:
        return 'const SizedBox()';
    }
  }

  Color? _parseColor(dynamic colorValue) {
    if (colorValue == null) return null;
    if (colorValue is int) return Color(colorValue);
    if (colorValue is Color) return colorValue;
    return null;
  }

  String _getBorderCode(
      String borderStyle, Color borderColor, double borderRadius) {
    switch (borderStyle) {
      case 'underline':
        return 'UnderlineInputBorder(borderSide: BorderSide(color: Color(0x${borderColor.value.toRadixString(16)})))';
      case 'none':
        return 'InputBorder.none';
      default:
        return 'OutlineInputBorder(borderRadius: BorderRadius.circular($borderRadius), borderSide: BorderSide(color: Color(0x${borderColor.value.toRadixString(16)})))';
    }
  }

  String _getMainAxisAlignmentCode(String? alignment) {
    switch (alignment) {
      case 'center':
        return 'MainAxisAlignment.center';
      case 'end':
        return 'MainAxisAlignment.end';
      case 'spaceBetween':
        return 'MainAxisAlignment.spaceBetween';
      case 'spaceAround':
        return 'MainAxisAlignment.spaceAround';
      case 'spaceEvenly':
        return 'MainAxisAlignment.spaceEvenly';
      default:
        return 'MainAxisAlignment.start';
    }
  }

  String _getCrossAxisAlignmentCode(String? alignment) {
    switch (alignment) {
      case 'start':
        return 'CrossAxisAlignment.start';
      case 'end':
        return 'CrossAxisAlignment.end';
      case 'stretch':
        return 'CrossAxisAlignment.stretch';
      case 'baseline':
        return 'CrossAxisAlignment.baseline';
      default:
        return 'CrossAxisAlignment.center';
    }
  }
}

class CanvasColorPicker extends StatelessWidget {
  const CanvasColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppBuilderState>();

    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Canvas Background Color',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ColorPicker(
              pickerColor: state.canvasColor,
              onColorChanged: (color) {
                state.updateCanvasColor(color);
              },
              pickerAreaHeightPercent: 0.7,
              enableAlpha: false,
              displayThumbColor: true,
              paletteType: PaletteType.hsvWithHue,
              labelTypes: const [],
              pickerAreaBorderRadius:
                  const BorderRadius.all(Radius.circular(10)),
              hexInputBar: true,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetDrawer extends StatelessWidget {
  const WidgetDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final widgets = [
      {'type': 'Text', 'icon': Icons.text_fields},
      {'type': 'Button', 'icon': Icons.smart_button},
      {'type': 'Container', 'icon': Icons.check_box_outline_blank},
      {'type': 'Image', 'icon': Icons.image},
      {'type': 'TextField', 'icon': Icons.edit},
      {'type': 'Icon', 'icon': Icons.star},
      {'type': 'Card', 'icon': Icons.crop_square},
      {'type': 'Row', 'icon': Icons.view_week},
      {'type': 'Column', 'icon': Icons.view_stream},
      {'type': 'ListView', 'icon': Icons.list},
    ];

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Widget Palette',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Drag & drop widgets to canvas',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          ...widgets.map((widget) => ListTile(
                leading: Icon(widget['icon'] as IconData),
                title: Text(widget['type'] as String),
                onTap: () {
                  context
                      .read<AppBuilderState>()
                      .addWidget(widget['type'] as String);
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }

  Widget _buildDraggableWidget(
      String type, IconData icon, BuildContext context) {
    return Draggable<String>(
      data: type,
      child: ListTile(
        leading: Icon(icon),
        title: Text(type),
      ),
      feedback: Material(
        child: ListTile(
          leading: Icon(icon),
          title: Text(type),
        ),
      ),
    );
  }
}

class BuilderCanvas extends StatelessWidget {
  const BuilderCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppBuilderState>(
      builder: (context, state, child) {
        return Stack(
          children: [
            for (var widget in state.currentScreenWidgets)
              Positioned(
                left: widget.position.dx,
                top: widget.position.dy,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    state.updateWidgetPosition(widget.id, details.delta);
                  },
                  onTap: () {
                    _showPropertiesSheet(context, widget);
                  },
                  onDoubleTap: () {
                    _showLayerOptions(context, widget, state);
                  },
                  onLongPress: () {
                    _showRemoveDialog(context, widget, state);
                  },
                  child: widget.buildWidget(),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showPropertiesSheet(BuildContext context, BuilderWidget widget) {
    showModalBottomSheet(
      context: context,
      builder: (context) => PropertyEditor(widget: widget),
    );
  }

  void _showLayerOptions(
      BuildContext context, BuilderWidget widget, AppBuilderState state) {
    showDialog(
      context: context,
      builder: (context) => LayerOptionsDialog(widget: widget, state: state),
    );
  }

  void _showRemoveDialog(
      BuildContext context, BuilderWidget widget, AppBuilderState state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Widget'),
        content: Text('Do you want to remove this ${widget.type} widget?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              state.removeWidget(widget.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

class PropertyEditor extends StatelessWidget {
  final BuilderWidget widget;

  const PropertyEditor({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Edit ${widget.type} Properties',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: _buildPropertyFields(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyFields(BuildContext context) {
    final state = context.read<AppBuilderState>();

    switch (widget.type) {
      case 'Text':
        return Column(
          children: [
            _buildTextField(
              label: 'Text Content',
              value: widget.properties['text'] ?? 'Text',
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'text',
                value,
              ),
            ),
            _buildColorPicker(
              context: context,
              label: 'Text Color',
              value: _parseColor(widget.properties['color']) ?? Colors.black,
              onChanged: (color) => state.updateWidgetProperty(
                widget.id,
                'color',
                color.value,
              ),
            ),
            _buildCustomSlider(
              label: 'Font Size',
              value: widget.properties['fontSize']?.toDouble() ?? 14.0,
              min: 8.0,
              max: 48.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'fontSize',
                value,
              ),
            ),
          ],
        );

      case 'Button':
        return Column(
          children: [
            _buildTextField(
              label: 'Button Text',
              value: widget.properties['text'] ?? 'Button',
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'text',
                value,
              ),
            ),
            _buildDropdown(
              label: 'Button Style',
              value: widget.properties['buttonStyle'] ?? 'elevated',
              options: const ['elevated', 'outlined', 'text'],
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'buttonStyle',
                value,
              ),
            ),
            _buildDropdown(
              label: 'Icon',
              value: widget.properties['icon'] ?? 'none',
              options: const [
                'none',
                'add',
                'delete',
                'edit',
                'save',
                'close',
                'check',
                'settings',
                'search',
                'menu',
                'home',
                'favorite',
                'star',
                'upload',
                'download',
                'share'
              ],
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'icon',
                value,
              ),
            ),
            if (widget.properties['icon'] != null &&
                widget.properties['icon'] != 'none')
              _buildDropdown(
                label: 'Icon Position',
                value: widget.properties['iconPosition'] ?? 'start',
                options: const ['start', 'end'],
                onChanged: (value) => state.updateWidgetProperty(
                  widget.id,
                  'iconPosition',
                  value,
                ),
              ),
            _buildColorPicker(
              context: context,
              label: 'Button Color',
              value: _parseColor(widget.properties['color']) ?? Colors.blue,
              onChanged: (color) => state.updateWidgetProperty(
                widget.id,
                'color',
                color.value,
              ),
            ),
            _buildColorPicker(
              context: context,
              label: 'Text Color',
              value:
                  _parseColor(widget.properties['textColor']) ?? Colors.white,
              onChanged: (color) => state.updateWidgetProperty(
                widget.id,
                'textColor',
                color.value,
              ),
            ),
            _buildCustomSlider(
              label: 'Width',
              value: widget.properties['width']?.toDouble() ?? 120.0,
              min: 60.0,
              max: 300.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'width',
                value,
              ),
            ),
            _buildCustomSlider(
              label: 'Height',
              value: widget.properties['height']?.toDouble() ?? 40.0,
              min: 30.0,
              max: 100.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'height',
                value,
              ),
            ),
            _buildCustomSlider(
              label: 'Border Radius',
              value: widget.properties['borderRadius']?.toDouble() ?? 4.0,
              min: 0.0,
              max: 50.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'borderRadius',
                value,
              ),
            ),
          ],
        );

      case 'TextField':
        return Column(
          children: [
            _buildTextField(
              label: 'Hint Text',
              value: widget.properties['hint'] ?? 'Enter text',
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'hint',
                value,
              ),
            ),
            _buildCustomSlider(
              label: 'Width',
              value: widget.properties['width']?.toDouble() ?? 200.0,
              min: 50.0,
              max: 500.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'width',
                value,
              ),
            ),
            _buildColorPicker(
              context: context,
              label: 'Text Color',
              value:
                  _parseColor(widget.properties['textColor']) ?? Colors.black,
              onChanged: (color) => state.updateWidgetProperty(
                widget.id,
                'textColor',
                color.value,
              ),
            ),
            _buildColorPicker(
              context: context,
              label: 'Background Color',
              value: _parseColor(widget.properties['backgroundColor']) ??
                  Colors.white,
              onChanged: (color) => state.updateWidgetProperty(
                widget.id,
                'backgroundColor',
                color.value,
              ),
            ),
            _buildDropdown(
              label: 'Border Style',
              value: widget.properties['borderStyle'] ?? 'outline',
              options: const ['outline', 'underline', 'none'],
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'borderStyle',
                value,
              ),
            ),
            _buildColorPicker(
              context: context,
              label: 'Border Color',
              value:
                  _parseColor(widget.properties['borderColor']) ?? Colors.grey,
              onChanged: (color) => state.updateWidgetProperty(
                widget.id,
                'borderColor',
                color.value,
              ),
            ),
            _buildCustomSlider(
              label: 'Border Radius',
              value: widget.properties['borderRadius']?.toDouble() ?? 4.0,
              min: 0.0,
              max: 50.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'borderRadius',
                value,
              ),
            ),
          ],
        );

      case 'Row':
      case 'Column':
        return Column(
          children: [
            _buildDropdown(
              label: 'Main Axis Alignment',
              value: widget.properties['mainAxisAlignment'] ?? 'start',
              options: const [
                'start',
                'center',
                'end',
                'spaceBetween',
                'spaceAround',
                'spaceEvenly'
              ],
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'mainAxisAlignment',
                value,
              ),
            ),
            _buildDropdown(
              label: 'Cross Axis Alignment',
              value: widget.properties['crossAxisAlignment'] ?? 'center',
              options: const ['start', 'center', 'end', 'stretch', 'baseline'],
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'crossAxisAlignment',
                value,
              ),
            ),
            _buildCustomSlider(
              label: widget.type == 'Row' ? 'Height' : 'Width',
              value: widget.properties['size']?.toDouble() ?? 100.0,
              min: 50.0,
              max: 500.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'size',
                value,
              ),
            ),
            _buildColorPicker(
              context: context,
              label: 'Background Color',
              value: _parseColor(widget.properties['backgroundColor']) ??
                  Colors.transparent,
              onChanged: (color) => state.updateWidgetProperty(
                widget.id,
                'backgroundColor',
                color.value,
              ),
            ),
            _buildCustomSlider(
              label: 'Padding',
              value: widget.properties['padding']?.toDouble() ?? 8.0,
              min: 0.0,
              max: 50.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'padding',
                value,
              ),
            ),
            _buildCustomSlider(
              label: 'Spacing',
              value: widget.properties['spacing']?.toDouble() ?? 8.0,
              min: 0.0,
              max: 50.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'spacing',
                value,
              ),
            ),
          ],
        );

      case 'Icon':
        return Column(
          children: [
            _buildIconPicker(
              context: context,
              label: 'Icon',
              value: widget.properties['iconData'] ?? Icons.star.codePoint,
              onChanged: (iconData) => state.updateWidgetProperty(
                widget.id,
                'iconData',
                iconData,
              ),
            ),
            _buildColorPicker(
              context: context,
              label: 'Icon Color',
              value: _parseColor(widget.properties['color']) ?? Colors.black,
              onChanged: (color) => state.updateWidgetProperty(
                widget.id,
                'color',
                color.value,
              ),
            ),
            _buildCustomSlider(
              label: 'Size',
              value: widget.properties['size']?.toDouble() ?? 24.0,
              min: 8.0,
              max: 128.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'size',
                value,
              ),
            ),
            _buildCustomSlider(
              label: 'Rotation (degrees)',
              value: widget.properties['rotation']?.toDouble() ?? 0.0,
              min: 0.0,
              max: 360.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'rotation',
                value,
              ),
            ),
          ],
        );

      case 'Image':
        return Column(
          children: [
            _buildTextField(
              label: 'Image URL',
              value: widget.properties['url'] ?? '',
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'url',
                value,
              ),
            ),
          ],
        );

      case 'Card':
        return Column(
          children: [
            _buildCustomSlider(
              label: 'Width',
              value: widget.properties['width']?.toDouble() ?? 200.0,
              min: 50.0,
              max: 500.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'width',
                value,
              ),
            ),
            _buildCustomSlider(
              label: 'Height',
              value: widget.properties['height']?.toDouble() ?? 100.0,
              min: 50.0,
              max: 500.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'height',
                value,
              ),
            ),
            _buildColorPicker(
              context: context,
              label: 'Background Color',
              value: _parseColor(widget.properties['color']) ?? Colors.white,
              onChanged: (color) => state.updateWidgetProperty(
                widget.id,
                'color',
                color.value,
              ),
            ),
          ],
        );

      case 'Container':
        return Column(
          children: [
            _buildColorPicker(
              context: context,
              label: 'Background Color',
              value: _parseColor(widget.properties['backgroundColor']) ??
                  Colors.blue,
              onChanged: (color) => state.updateWidgetProperty(
                widget.id,
                'backgroundColor',
                color.value,
              ),
            ),
            _buildCustomSlider(
              label: 'Width',
              value: widget.properties['width']?.toDouble() ?? 100.0,
              min: 50.0,
              max: 500.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'width',
                value,
              ),
            ),
            _buildCustomSlider(
              label: 'Height',
              value: widget.properties['height']?.toDouble() ?? 100.0,
              min: 50.0,
              max: 500.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'height',
                value,
              ),
            ),
            _buildCustomSlider(
              label: 'Border Radius',
              value: widget.properties['borderRadius']?.toDouble() ?? 0.0,
              min: 0.0,
              max: 50.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'borderRadius',
                value,
              ),
            ),
            _buildCustomSlider(
              label: 'Border Width',
              value: widget.properties['borderWidth']?.toDouble() ?? 1.0,
              min: 0.0,
              max: 10.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'borderWidth',
                value,
              ),
            ),
            _buildColorPicker(
              context: context,
              label: 'Border Color',
              value:
                  _parseColor(widget.properties['borderColor']) ?? Colors.grey,
              onChanged: (color) => state.updateWidgetProperty(
                widget.id,
                'borderColor',
                color.value,
              ),
            ),
          ],
        );

      case 'ListView':
        return Column(
          children: [
            _buildDropdown(
              label: 'Scroll Direction',
              value: widget.properties['scrollDirection'] ?? 'vertical',
              options: const ['vertical', 'horizontal'],
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'scrollDirection',
                value,
              ),
            ),
            _buildCustomSlider(
              label: 'Width',
              value: widget.properties['width']?.toDouble() ?? 200.0,
              min: 100.0,
              max: 500.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'width',
                value,
              ),
            ),
            _buildCustomSlider(
              label: 'Height',
              value: widget.properties['height']?.toDouble() ?? 300.0,
              min: 100.0,
              max: 500.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'height',
                value,
              ),
            ),
            _buildCustomSlider(
              label: 'Padding',
              value: widget.properties['padding']?.toDouble() ?? 8.0,
              min: 0.0,
              max: 50.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'padding',
                value,
              ),
            ),
            _buildCustomSlider(
              label: 'Spacing',
              value: widget.properties['spacing']?.toDouble() ?? 8.0,
              min: 0.0,
              max: 50.0,
              onChanged: (value) => state.updateWidgetProperty(
                widget.id,
                'spacing',
                value,
              ),
            ),
            _buildColorPicker(
              context: context,
              label: 'Background Color',
              value: _parseColor(widget.properties['backgroundColor']) ??
                  Colors.transparent,
              onChanged: (color) => state.updateWidgetProperty(
                widget.id,
                'backgroundColor',
                color.value,
              ),
            ),
          ],
        );

      default:
        return const Center(
          child: Text('No properties available for this widget'),
        );
    }
  }

  Color? _parseColor(dynamic colorValue) {
    if (colorValue == null) return null;
    if (colorValue is int) return Color(colorValue);
    if (colorValue is Color) return colorValue;
    return null;
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        controller: TextEditingController(text: value),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildColorPicker({
    required BuildContext context,
    required String label,
    required Color value,
    required ValueChanged<Color> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: value,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Pick a $label'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: value,
                            onColorChanged: onChanged,
                            pickerAreaHeightPercent: 0.8,
                            enableAlpha: false,
                            displayThumbColor: true,
                            paletteType: PaletteType.hsvWithHue,
                            labelTypes: const [],
                            pickerAreaBorderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            hexInputBar: true,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Done'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Choose Color'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconPicker({
    required BuildContext context,
    required String label,
    required int value,
    required ValueChanged<int> onChanged,
  }) {
    final icons = {
      'add': Icons.add,
      'home': Icons.home,
      'person': Icons.person,
      'settings': Icons.settings,
      'favorite': Icons.favorite,
      'star': Icons.star,
      'search': Icons.search,
      'menu': Icons.menu,
      'close': Icons.close,
      'check': Icons.check,
      'edit': Icons.edit,
      'delete': Icons.delete,
      'share': Icons.share,
      'download': Icons.download,
      'upload': Icons.upload,
      'refresh': Icons.refresh,
      'camera': Icons.camera,
      'image': Icons.image,
      'video': Icons.video_camera_back,
      'music': Icons.music_note,
      'phone': Icons.phone,
      'email': Icons.email,
      'message': Icons.message,
      'notification': Icons.notifications,
      'calendar': Icons.calendar_today,
      'clock': Icons.access_time,
      'location': Icons.location_on,
      'bookmark': Icons.bookmark,
      'shopping_cart': Icons.shopping_cart,
      'attach': Icons.attach_file,
      'link': Icons.link,
      'cloud': Icons.cloud,
      'folder': Icons.folder,
      'file': Icons.file_present,
      'print': Icons.print,
      'save': Icons.save,
      'copy': Icons.content_copy,
      'paste': Icons.content_paste,
      'cut': Icons.content_cut,
      'undo': Icons.undo,
      'redo': Icons.redo,
      'zoom_in': Icons.zoom_in,
      'zoom_out': Icons.zoom_out,
      'fullscreen': Icons.fullscreen,
      'exit_fullscreen': Icons.fullscreen_exit,
      'volume_up': Icons.volume_up,
      'volume_down': Icons.volume_down,
      'volume_mute': Icons.volume_mute,
      'play': Icons.play_arrow,
      'pause': Icons.pause,
      'stop': Icons.stop,
      'fast_forward': Icons.fast_forward,
      'fast_rewind': Icons.fast_rewind,
      'skip_next': Icons.skip_next,
      'skip_previous': Icons.skip_previous,
      'shuffle': Icons.shuffle,
      'repeat': Icons.repeat,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 8),
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: icons.length,
              itemBuilder: (context, index) {
                final iconData = icons.values.elementAt(index);
                final isSelected = iconData.codePoint == value;
                return InkWell(
                  onTap: () => onChanged(iconData.codePoint),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor.withOpacity(0.1)
                          : null,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      iconData,
                      size: 24,
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Selected: ${icons.entries.firstWhere((entry) => entry.value.codePoint == value, orElse: () => const MapEntry('star', Icons.star)).key}',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    final controller = TextEditingController(text: value.toString());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  onChanged: (newValue) {
                    controller.text = newValue.toString();
                    onChanged(newValue);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: controller,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onChanged: (value) {
                    final newValue = double.tryParse(value);
                    if (newValue != null) {
                      final clampedValue = newValue.clamp(min, max);
                      if (clampedValue != newValue) {
                        controller.text = clampedValue.toString();
                      }
                      onChanged(clampedValue);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  onChanged: onChanged,
                ),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  value.toString(),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: const SizedBox(),
              items: options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LayerOptionsDialog extends StatelessWidget {
  final BuilderWidget widget;
  final AppBuilderState state;

  const LayerOptionsDialog(
      {super.key, required this.widget, required this.state});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Layer Options for ${widget.type} Widget'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.vertical_align_top),
            label: const Text('Bring to Front'),
            onPressed: () {
              state.bringToFront(widget.id);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.vertical_align_bottom),
            label: const Text('Send to Back'),
            onPressed: () {
              state.sendToBack(widget.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class BuilderWidget {
  final String id;
  final String type;
  Offset position;
  Map<String, dynamic> properties;
  List<BuilderWidget> children;

  BuilderWidget({
    required this.id,
    required this.type,
    required this.position,
    Map<String, dynamic>? properties,
    List<BuilderWidget>? children,
  })  : properties = properties ?? {},
        children = children ?? [];

  Widget buildWidget() {
    final context = navigatorKey.currentContext!;
    final state = Provider.of<AppBuilderState>(context, listen: false);

    switch (type) {
      case 'Text':
        return Text(
          properties['text'] ?? 'Text',
          style: TextStyle(
            color: _parseColor(properties['color']) ?? Colors.black,
            fontSize: properties['fontSize']?.toDouble() ?? 14.0,
          ),
        );

      case 'Button':
        final buttonStyle = properties['buttonStyle'] ?? 'elevated';
        final iconData = _getIconData(properties['icon']);
        final iconPosition = properties['iconPosition'] ?? 'start';

        Widget buttonChild;
        if (iconData != null) {
          final icon = Icon(iconData);
          final text = Text(properties['text'] ?? 'Button');
          buttonChild = Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: iconPosition == 'start'
                ? [icon, const SizedBox(width: 8), text]
                : [text, const SizedBox(width: 8), icon],
          );
        } else {
          buttonChild = Text(properties['text'] ?? 'Button');
        }

        final buttonWidget = () {
          switch (buttonStyle) {
            case 'outlined':
              return OutlinedButton(
                onPressed: null,
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      _parseColor(properties['textColor']) ?? Colors.white,
                  disabledForegroundColor:
                      _parseColor(properties['textColor']) ?? Colors.white,
                  side: BorderSide(
                    color: _parseColor(properties['color']) ?? Colors.blue,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      properties['borderRadius']?.toDouble() ?? 4.0,
                    ),
                  ),
                ),
                child: buttonChild,
              );
            case 'text':
              return TextButton(
                onPressed: null,
                style: TextButton.styleFrom(
                  foregroundColor:
                      _parseColor(properties['color']) ?? Colors.blue,
                  disabledForegroundColor:
                      _parseColor(properties['color']) ?? Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      properties['borderRadius']?.toDouble() ?? 4.0,
                    ),
                  ),
                ),
                child: buttonChild,
              );
            default:
              return ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _parseColor(properties['color']) ?? Colors.blue,
                  disabledBackgroundColor:
                      _parseColor(properties['color']) ?? Colors.blue,
                  foregroundColor:
                      _parseColor(properties['textColor']) ?? Colors.white,
                  disabledForegroundColor:
                      _parseColor(properties['textColor']) ?? Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      properties['borderRadius']?.toDouble() ?? 4.0,
                    ),
                  ),
                ),
                child: buttonChild,
              );
          }
        }();

        return SizedBox(
          width: properties['width']?.toDouble() ?? 120.0,
          height: properties['height']?.toDouble() ?? 40.0,
          child: buttonWidget,
        );

      case 'TextField':
        InputBorder getBorder() {
          final borderStyle = properties['borderStyle'] ?? 'outline';
          final borderColor =
              _parseColor(properties['borderColor']) ?? Colors.grey;
          final borderRadius = properties['borderRadius']?.toDouble() ?? 4.0;

          switch (borderStyle) {
            case 'underline':
              return UnderlineInputBorder(
                borderSide: BorderSide(color: borderColor),
              );
            case 'none':
              return InputBorder.none;
            default:
              return OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor),
              );
          }
        }

        return AbsorbPointer(
          child: SizedBox(
            width: properties['width']?.toDouble() ?? 200.0,
            child: TextField(
              decoration: InputDecoration(
                hintText: properties['hint'] ?? 'Enter text',
                filled: true,
                fillColor:
                    _parseColor(properties['backgroundColor']) ?? Colors.white,
                border: getBorder(),
                enabledBorder: getBorder(),
                focusedBorder: getBorder(),
              ),
              style: TextStyle(
                color: _parseColor(properties['textColor']) ?? Colors.black,
              ),
            ),
          ),
        );

      case 'Row':
      case 'Column':
        final isRow = type == 'Row';
        final mainAxisAlignment = () {
          switch (properties['mainAxisAlignment'] ?? 'start') {
            case 'center':
              return MainAxisAlignment.center;
            case 'end':
              return MainAxisAlignment.end;
            case 'spaceBetween':
              return MainAxisAlignment.spaceBetween;
            case 'spaceAround':
              return MainAxisAlignment.spaceAround;
            case 'spaceEvenly':
              return MainAxisAlignment.spaceEvenly;
            default:
              return MainAxisAlignment.start;
          }
        }();

        final crossAxisAlignment = () {
          switch (properties['crossAxisAlignment'] ?? 'center') {
            case 'start':
              return CrossAxisAlignment.start;
            case 'end':
              return CrossAxisAlignment.end;
            case 'stretch':
              return CrossAxisAlignment.stretch;
            case 'baseline':
              return CrossAxisAlignment.baseline;
            default:
              return CrossAxisAlignment.center;
          }
        }();

        final size = properties['size']?.toDouble() ?? 100.0;
        final padding = properties['padding']?.toDouble() ?? 8.0;
        final spacing = properties['spacing']?.toDouble() ?? 8.0;
        final backgroundColor =
            _parseColor(properties['backgroundColor']) ?? Colors.transparent;

        return DragTarget<String>(
          onAccept: (widgetType) {
            final newWidget = BuilderWidget(
              id: DateTime.now().toString(),
              type: widgetType,
              position: const Offset(0, 0),
            );
            state.addChildWidget(id, newWidget);
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: isRow ? null : size,
              height: isRow ? size : null,
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
              child: isRow
                  ? Row(
                      mainAxisAlignment: mainAxisAlignment,
                      crossAxisAlignment: crossAxisAlignment,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...children.map((child) => Padding(
                              padding: EdgeInsets.all(spacing),
                              child: child.buildWidget(),
                            )),
                        if (children.isEmpty)
                          Container(
                            padding: EdgeInsets.all(spacing),
                            child: const Text('Drop widgets here'),
                          ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: mainAxisAlignment,
                      crossAxisAlignment: crossAxisAlignment,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...children.map((child) => Padding(
                              padding: EdgeInsets.all(spacing),
                              child: child.buildWidget(),
                            )),
                        if (children.isEmpty)
                          Container(
                            padding: EdgeInsets.all(spacing),
                            child: const Text('Drop widgets here'),
                          ),
                      ],
                    ),
            );
          },
        );

      case 'ListView':
        final scrollDirection = properties['scrollDirection'] ?? 'vertical';
        final padding = properties['padding']?.toDouble() ?? 8.0;
        final spacing = properties['spacing']?.toDouble() ?? 8.0;
        final backgroundColor =
            _parseColor(properties['backgroundColor']) ?? Colors.transparent;
        final width = properties['width']?.toDouble() ?? 200.0;
        final height = properties['height']?.toDouble() ?? 300.0;

        return DragTarget<String>(
          onAccept: (widgetType) {
            final newWidget = BuilderWidget(
              id: DateTime.now().toString(),
              type: widgetType,
              position: const Offset(0, 0),
            );
            state.addChildWidget(id, newWidget);
          },
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: Colors.grey.withOpacity(0.5)),
              ),
              child: ListView(
                scrollDirection: scrollDirection == 'horizontal'
                    ? Axis.horizontal
                    : Axis.vertical,
                padding: EdgeInsets.all(padding),
                children: [
                  ...children.map((child) => Padding(
                        padding: EdgeInsets.all(spacing),
                        child: child.buildWidget(),
                      )),
                  if (children.isEmpty)
                    Container(
                      padding: EdgeInsets.all(spacing),
                      child: const Text('Drop widgets here'),
                    ),
                ],
              ),
            );
          },
        );

      case 'Icon':
        final iconData = IconData(
          properties['iconData'] ?? Icons.star.codePoint,
          fontFamily: 'MaterialIcons',
        );
        return Transform.rotate(
          angle: (properties['rotation']?.toDouble() ?? 0.0) * 3.14159 / 180,
          child: Icon(
            iconData,
            size: properties['size']?.toDouble() ?? 24.0,
            color: _parseColor(properties['color']) ?? Colors.black,
          ),
        );

      case 'Image':
        return Container(
          width: properties['width'] ?? 150.0,
          height: properties['height'] ?? 150.0,
          color: Colors.grey[300],
          child: const Icon(Icons.image, size: 50),
        );

      case 'Card':
        return Card(
          child: Container(
            width: properties['width'] ?? 200.0,
            height: properties['height'] ?? 100.0,
            padding: const EdgeInsets.all(16),
            child: const Center(child: Text('Card Content')),
          ),
        );

      case 'Container':
        final backgroundColor =
            _parseColor(properties['backgroundColor']) ?? Colors.blue;
        final width = properties['width']?.toDouble() ?? 100.0;
        final height = properties['height']?.toDouble() ?? 100.0;
        final borderRadius = properties['borderRadius']?.toDouble() ?? 0.0;
        final borderWidth = properties['borderWidth']?.toDouble() ?? 1.0;
        final borderColor =
            _parseColor(properties['borderColor']) ?? Colors.grey;

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
          ),
        );

      default:
        return const SizedBox();
    }
  }

  Color? _parseColor(dynamic colorValue) {
    if (colorValue == null) return null;
    if (colorValue is int) return Color(colorValue);
    if (colorValue is Color) return colorValue;
    return null;
  }

  IconData? _getIconData(String? iconName) {
    switch (iconName) {
      case 'add':
        return Icons.add;
      case 'delete':
        return Icons.delete;
      case 'edit':
        return Icons.edit;
      case 'save':
        return Icons.save;
      case 'close':
        return Icons.close;
      case 'check':
        return Icons.check;
      case 'settings':
        return Icons.settings;
      case 'search':
        return Icons.search;
      case 'menu':
        return Icons.menu;
      case 'home':
        return Icons.home;
      case 'favorite':
        return Icons.favorite;
      case 'star':
        return Icons.star;
      case 'upload':
        return Icons.upload;
      case 'download':
        return Icons.download;
      case 'share':
        return Icons.share;
      default:
        return null;
    }
  }
}

class AppBuilderState extends ChangeNotifier {
  List<Screen> screens = [Screen(id: '1', name: 'Screen 1')];
  int currentScreenIndex = 0;
  Color canvasColor = Colors.white;

  List<BuilderWidget> get currentScreenWidgets =>
      screens[currentScreenIndex].widgets;

  void updateCanvasColor(Color color) {
    canvasColor = color;
    notifyListeners();
  }

  void addWidget(String type) {
    screens[currentScreenIndex].widgets.add(
          BuilderWidget(
            id: DateTime.now().toString(),
            type: type,
            position: const Offset(100, 100),
          ),
        );
    notifyListeners();
  }

  void removeWidget(String id) {
    screens[currentScreenIndex]
        .widgets
        .removeWhere((widget) => widget.id == id);
    notifyListeners();
  }

  void updateWidgetPosition(String id, Offset delta) {
    final widget = currentScreenWidgets.firstWhere((w) => w.id == id);
    widget.position += delta;
    notifyListeners();
  }

  void updateWidgetProperty(String id, String property, dynamic value) {
    final widget = currentScreenWidgets.firstWhere((w) => w.id == id);
    widget.properties[property] = value;
    notifyListeners();
  }

  void addNewScreen() {
    screens.add(
      Screen(
        id: (screens.length + 1).toString(),
        name: 'Screen ${screens.length + 1}',
      ),
    );
    notifyListeners();
  }

  void addChildWidget(String parentId, BuilderWidget child) {
    final parentWidget =
        currentScreenWidgets.firstWhere((w) => w.id == parentId);
    parentWidget.children.add(child);
    notifyListeners();
  }

  void removeChildWidget(String parentId, String childId) {
    final parentWidget =
        currentScreenWidgets.firstWhere((w) => w.id == parentId);
    parentWidget.children.removeWhere((child) => child.id == childId);
    notifyListeners();
  }

  void bringToFront(String id) {
    final index = currentScreenWidgets.indexWhere((w) => w.id == id);
    if (index != -1) {
      final widget = currentScreenWidgets.removeAt(index);
      currentScreenWidgets.add(widget);
      notifyListeners();
    }
  }

  void sendToBack(String id) {
    final index = currentScreenWidgets.indexWhere((w) => w.id == id);
    if (index != -1) {
      final widget = currentScreenWidgets.removeAt(index);
      currentScreenWidgets.insert(0, widget);
      notifyListeners();
    }
  }
}

class Screen {
  final String id;
  final String name;
  final List<BuilderWidget> widgets;

  Screen({
    required this.id,
    required this.name,
    List<BuilderWidget>? widgets,
  }) : widgets = widgets ?? [];
}
