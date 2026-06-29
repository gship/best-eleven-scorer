import 'package:flutter/material.dart';

Future<void> showManagerResetDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder:
        (BuildContext context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          content: Text(
            'Changing manager/formation changes formation. You will need to re-enter your team.',
            style: TextStyle(
              fontSize: 18.0, // <-- Adjust content size here
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 18.0, // <-- Adjust content size here
                ),
              ),
            ),
          ],
        ),
  );
}
