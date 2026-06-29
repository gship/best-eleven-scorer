import 'package:flutter/material.dart';

void showTeamsReviewDialog(BuildContext context) async {
  showDialog<String>(
    context: context,
    builder:
        (BuildContext context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          content: Text(
            'To change any row click on the icon to the left of the row, otherwise click NEXT',
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
