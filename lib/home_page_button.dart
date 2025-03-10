import 'package:flutter/material.dart';

class HomePageButton extends StatelessWidget {
  const HomePageButton({
    required this.leftRight,
    required this.topBottom,
    required this.buttonText,
    required this.onPressed,
    super.key,
  });

  final double leftRight;
  final double topBottom;
  final void Function()? onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        child: ElevatedButton(
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(
              EdgeInsets.fromLTRB(leftRight, topBottom, leftRight, topBottom),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
            minimumSize: const WidgetStatePropertyAll(Size(100, 60)),
            backgroundColor: WidgetStateProperty.all(Colors.black),
            foregroundColor: WidgetStateProperty.all(Colors.white),
            overlayColor: WidgetStatePropertyAll<Color>(Colors.pink),
          ),
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w100),
          ),
        ),
      ),
    );
  }
}
