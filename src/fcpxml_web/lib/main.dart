import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  String _timeStamps = "Upload a .fcpxml file!";

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
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Text(_timeStamps)])),
      floatingActionButton: Row(mainAxisAlignment: MainAxisAlignment.end, spacing: 10, children: <Widget>[
          FileUploadButton(isLoading: _isLoading, setIsLoading: _setIsLoading, setTimeStamps: _setTimeStamps),
          ClearTimeStampsButton(setTimeStamps: _setTimeStamps)
        ]
      )
      ,
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
      child: Icon(Icons.refresh_sharp)
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
        var picked = await FilePicker.platform.pickFiles();
        if (picked != null) {
          // print(picked.files.first.name);
          // print(picked.files.first.bytes);

          setIsLoading(true);
          await Future.delayed(Duration(seconds: 3));
          setTimeStamps("test");
          setIsLoading(false);
        }
      },
      child: isLoading ? const Icon(Icons.warning) : const Icon(Icons.add),
    );
  }
}


      // Future<void>  upload() async {
      //   for (var i = 0; i < files.length; i++) {
      //     final file = files[i];
      //     final completer = Completer<List<int>>();
      //     final reader = FileReader();

      //     reader.onLoad.listen((event) {
      //       final bytesData = reader.result as List<int>;
      //       completer.complete(bytesData);
      //     });

      //     reader.readAsArrayBuffer(file);
      //     final bytesData = await completer.future;
      //     final request = http.MultipartRequest("POST", Uri.parse(url));
      //     final headers = {
      //       "Authorization": "Bearer $token",
      //       "Content-Type": "multipart/form-data",
      //       "Content-Length": bytesData.length.toString(),
      //       "Accept": "*/*",
      //     };
      //     request.headers.addAll(headers);
      //     if (requestFields != null) {
      //       request.fields.addAll(requestFields!);
      //     }
      //     request.files.add(http.MultipartFile.fromBytes(
      //       'files',
      //       bytesData,
      //       filename: file.name,
      //     ));
      //     final response = await request.send();
      //     handleResponse(response);
      //   }
      // }