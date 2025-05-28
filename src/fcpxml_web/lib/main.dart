import 'package:fcpxml_web/widgets/DropFileZone.dart';
import 'package:flutter/material.dart';
import 'widgets/ClearTimeStampsButton.dart';
import 'widgets/FileUploadButton.dart';

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
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          SelectableText(_timeStamps),
          DropFileZone(setTimeStamps: _setTimeStamps),
        ]),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 10,
        children: <Widget>[
          FileUploadButton(isLoading: _isLoading, setIsLoading: _setIsLoading, setTimeStamps: _setTimeStamps),
          ClearTimeStampsButton(setTimeStamps: _setTimeStamps, setIsLoading: _setIsLoading),
        ],
      ),
    );
  }
}
