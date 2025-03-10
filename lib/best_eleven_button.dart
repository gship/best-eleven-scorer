import 'package:flutter/material.dart';

class BestElevenButton extends StatelessWidget {
  const BestElevenButton({
    required this.buttonText,
    required this.onPressed,
    super.key,
  });

  final void Function()? onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.fromLTRB(40, 18, 40, 19)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          minimumSize: const WidgetStatePropertyAll(Size(100, 60)),
          backgroundColor: WidgetStateProperty.all(Colors.black),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          overlayColor: WidgetStatePropertyAll<Color>(Colors.pink),
        ),

        onPressed: onPressed,

        child: Text(buttonText, style: TextStyle(fontSize: 25.0)),
      ),
    );
  }
}
