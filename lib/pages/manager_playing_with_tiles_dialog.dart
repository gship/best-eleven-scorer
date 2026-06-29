import 'package:flutter/material.dart';
import '../routes.dart';
import '../core.dart';

Future<String?> showPlayingWithManagerTilesDialog(BuildContext context) async {
  return showDialog<String>(
    context: context,
    barrierDismissible: false, // User must tap a button to dismiss
    builder:
        (BuildContext context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          content: Text(
            'Are you playing with manager tiles? If you are, click YES, otherwise click NO',
            style: TextStyle(
              fontSize: 18.0, // <-- Adjust content size here
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, managerTileSelectPage);
              },
              child: const Text(
                'YES',
                style: TextStyle(
                  fontSize: 18.0, // <-- Adjust content size here
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (core.playingSolo) {
                  Navigator.pop(context, managerSoloSelectPage);
                } else {
                  Navigator.pop(context, managerSelectPage);
                }
              },
              child: const Text(
                'NO',
                style: TextStyle(
                  fontSize: 18.0, // <-- Adjust content size here
                ),
              ),
            ),
          ],
        ),
  );
}
