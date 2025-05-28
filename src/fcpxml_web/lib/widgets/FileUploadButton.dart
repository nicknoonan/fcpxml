import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../parser/XmlParser.dart';

class FileUploadButton extends StatelessWidget {
  FileUploadButton({required this.isLoading, required this.setIsLoading, required this.setTimeStamps, super.key}) {
    const host = String.fromEnvironment('FCPXML_HOST', defaultValue: 'localhost');
    this.parser = new Parser(host: host);
  }
  final bool isLoading;
  final ValueChanged<bool> setIsLoading;
  final ValueChanged<String> setTimeStamps;
  late Parser parser;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Upload a .fcpxml file to parse',
      onPressed: () async {
        var picked = await FilePicker.platform.pickFiles(withData: true);
        if (picked != null) {
          // print(picked.files.first.name);
          //print(picked.files.first.bytes);

          setIsLoading(true);
          setTimeStamps("Loading...");
          final timeStamps = await parser.parse(picked.files.first.bytes!.toList());
          setTimeStamps(timeStamps);
          setIsLoading(false);
        }
      },
      child: isLoading ? const Icon(Icons.warning) : const Icon(Icons.add),
    );
  }
}
