import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> showYesNoDialog(BuildContext context, String header, String query) async {
  bool retVal = false;
  await showDialog(
    context: context,
    barrierDismissible: false, // User must tap a button to dismiss
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Optional: rounded corners
          side: BorderSide(
            color: Colors.white, // Border color
            width: 2.0, // Border thickness
          ),
        ),
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.green, borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
          child: Text(header, style: TextStyle(color: Colors.white)),
        ),
        titlePadding: EdgeInsets.zero,
        content: Text(query),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              debugPrint('$query The answer is yes ...');
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
              debugPrint('$query The answer is no ...');
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
      );
    },
  );
  return retVal;
}

Future<void> showOkDialog(BuildContext context, String header, String phrase) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Optional: rounded corners
          side: BorderSide(
            color: Colors.white, // Border color
            width: 2.0, // Border thickness
          ),
        ),
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.green, borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
          child: Text(header, style: TextStyle(color: Colors.white)),
        ),
        titlePadding: EdgeInsets.zero,
        content: Text(phrase),
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
      );
    },
  );
}

Future<int> showNumberEntryDialog(BuildContext context, String header, String query, int min, int max) async {
  int retVal = 0;
  TextEditingController textController = TextEditingController();
  textController.clear();
  final input = await showDialog<int>(
    context: context,
    barrierDismissible: false, // User must tap a button to dismiss
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Optional: rounded corners
          side: BorderSide(
            color: Colors.white, // Border color
            width: 2.0, // Border thickness
          ),
        ),
        title: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.green, borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
          child: Text(header, style: TextStyle(color: Colors.white)),
        ),
        titlePadding: EdgeInsets.zero,
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: '$query ($min-$max)', border: OutlineInputBorder()),
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Block non-digits like commas/hyphens
            MinMaxTextInputFormatter(min: 1, max: 4),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(int.parse(textController.text));
            },
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 18.0, // <-- Adjust content size here
              ),
            ),
          ),
        ],
      );
    },
  );

  retVal = input ?? 0; // Return 0 if input is null

  return retVal; // Return 0 if input is null
}

class MinMaxTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  MinMaxTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow the user to clear the text field completely
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Try to parse the new text into an integer
    final int? value = int.tryParse(newValue.text);

    // If it's not a valid number or falls outside min and max, reject the change
    if (value == null || value < min || value > max) {
      return oldValue;
    }

    // Accept the valid number
    return newValue;
  }
}
