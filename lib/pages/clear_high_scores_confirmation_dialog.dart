import 'package:flutter/material.dart';

Future<bool> showClearHighScoresConfirmationDialog(BuildContext context) async {
  bool retVal = false;
  debugPrint('in showClearHighScoresConfirmationDialog...');
  await showDialog<String>(
    context: context,
    builder:
        (BuildContext context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          content: Text('Do you really want to clear high scores?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                debugPrint('... they really want to clear high scores ...');
                retVal = true;
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                debugPrint('... they don\'t want to clear high scores ...');
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        ),
  );
  return retVal;
}
