import 'package:flutter/material.dart';

void showHomePageDialog(BuildContext context) async {
  showDialog<String>(
    context: context,
    builder:
        (BuildContext context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          content: Text(
            'Click on the three dots in the very top right for bonus games. Scroll down to see to see all buttons.',
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
