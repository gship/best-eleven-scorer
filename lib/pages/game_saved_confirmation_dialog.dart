import 'package:flutter/material.dart';

void showGameSavedConfirmationDialog(BuildContext context) async {
  debugPrint('in showGameSavedConfirmationDialog...');
  showDialog<String>(
    context: context,
    builder:
        (BuildContext context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          content: Text('Game saved'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
  );
}
