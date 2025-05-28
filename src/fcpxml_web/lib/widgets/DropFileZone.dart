import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import '../parser/XmlParser.dart';

class DropFileZone extends StatelessWidget {
  final ValueChanged<String> setTimeStamps;
  late Parser parser;
  DropFileZone({super.key, required this.setTimeStamps}) {
    const host = String.fromEnvironment('FCPXML_HOST', defaultValue: 'localhost');
    this.parser = new Parser(host: host);
  }

  @override
  Widget build(BuildContext context) {
    late DropzoneViewController controller;
    return Expanded(
      child: DropzoneView(
        operation: DragOperation.copy,
        cursor: CursorType.grab,
        onCreated: (ctrl) => controller = ctrl,
        onLoaded: () => print('Zone 1 loaded'),
        onError: (error) => print('Zone 1 error: $error'),
        onHover: () {},
        onLeave: () {},
        onDropFile: (file) async {
          print('Zone 1 drop: ${file.name}');
          final bytes = await controller.getFileData(file);
          final timeStamps = await parser.parse(bytes);
          setTimeStamps(timeStamps);
          print('Read bytes with length ${bytes.length}');
        },
        onDropString: (s) {
          print('Zone 1 drop: $s');
        },
        onDropInvalid: (mime) => print('Zone 1 invalid MIME: $mime'),
        onDropFiles: (files) => print('Zone 1 drop multiple: $files'),
        onDropStrings: (strings) => print('Zone 1 drop multiple: $strings'),
      ),
    );
  }
}
