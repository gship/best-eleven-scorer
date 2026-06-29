import 'package:flutter/material.dart';

Future<bool> showClearHighScoresConfirmationDialog(BuildContext context) async {
  bool retVal = false;
  await showDialog<String>(
    barrierDismissible: false,
    context: context,
    builder:
        (BuildContext context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          content: Text('Do you really want to clear high scores?',
            style: TextStyle(
              fontSize: 18.0, // <-- Adjust content size here
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                debugPrint('... they really want to clear high scores ...');
                retVal = true;
                Navigator.of(context).pop();
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  fontSize: 18.0, // <-- Adjust content size here
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                debugPrint('... they don\'t want to clear high scores ...');
                Navigator.of(context).pop();
              },
              child: const Text(
                'No',
                style: TextStyle(
                  fontSize: 18.0, // <-- Adjust content size here
                ),
              ),
            ),
          ],
        ),
  );
  return retVal;
}
