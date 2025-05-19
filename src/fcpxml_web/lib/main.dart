import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fcpxml parser',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Find chapter-markers in .fcpxml'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  String _timeStamps = "Upload a .fcpxml file to begin!";

  void _setTimeStamps(String timeStamps) {
    setState(() {
      _timeStamps = timeStamps;
    });
  }

  void _setIsLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[SelectableText(_timeStamps)]),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 10,
        children: <Widget>[
          FileUploadButton(isLoading: _isLoading, setIsLoading: _setIsLoading, setTimeStamps: _setTimeStamps),
          ClearTimeStampsButton(setTimeStamps: _setTimeStamps),
        ],
      ),
    );
  }
}

class ClearTimeStampsButton extends StatelessWidget {
  const ClearTimeStampsButton({super.key, required this.setTimeStamps});
  final ValueChanged<String> setTimeStamps;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Clear the timestamps on the screen',
      onPressed: () {
        setTimeStamps("Upload a .fcpxml file to begin!");
      },
      child: Icon(Icons.refresh_sharp),
    );
  }
}

class FileUploadButton extends StatelessWidget {
  const FileUploadButton({required this.isLoading, required this.setIsLoading, required this.setTimeStamps, super.key});
  final bool isLoading;
  final ValueChanged<bool> setIsLoading;
  final ValueChanged<String> setTimeStamps;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Upload a .fcpxml file to parse',
      onPressed: () async {
        var picked = await FilePicker.platform.pickFiles(withData: true);
        if (picked != null) {
          // print(picked.files.first.name);
          print(picked.files.first.bytes);

          setIsLoading(true);
          final uri = Uri.parse('http://localhost:8080/upload');
          var request = http.MultipartRequest('POST', uri);
          final httpImage = http.MultipartFile.fromBytes(
            'fcpxml',
            picked.files.first.bytes!.toList(),
            contentType: MediaType.parse("multipart/form-data"),
            filename: 'fcpxml',
          );
          request.files.add(httpImage);
          final response = await request.send();
          final responseString = await response.stream.bytesToString();
          setTimeStamps(responseString);
          setIsLoading(false);
        }
      },
      child: isLoading ? const Icon(Icons.warning) : const Icon(Icons.add),
    );
  }
}
