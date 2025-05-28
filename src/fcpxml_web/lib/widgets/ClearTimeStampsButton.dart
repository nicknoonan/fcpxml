import 'package:flutter/material.dart';

class ClearTimeStampsButton extends StatelessWidget {
  const ClearTimeStampsButton({super.key, required this.setTimeStamps, required this.setIsLoading});
  final ValueChanged<String> setTimeStamps;
  final ValueChanged<bool> setIsLoading;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Clear the timestamps on the screen',
      onPressed: () {
        setTimeStamps("Upload a .fcpxml file to begin!");
        setIsLoading(false);
      },
      child: Icon(Icons.refresh_sharp),
    );
  }
}
