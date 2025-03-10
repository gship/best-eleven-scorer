import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NextBackButton extends StatelessWidget {
  const NextBackButton(
      {required this.buttonText,
        required this.onPressed,
        required this.font,
        this.bold = false,
        super.key});

  final void Function()? onPressed;
  final String buttonText;
  final String font;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.fromLTRB(40, 17, 40, 17)),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0))
        ),
        minimumSize: const WidgetStatePropertyAll(Size(100, 60)),
        backgroundColor: WidgetStateProperty.all(Colors.black),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        overlayColor: WidgetStatePropertyAll<Color>(Colors.pink),
      ),

      onPressed: onPressed,

      child: Text(
        buttonText,
        /*
        style: TextStyle(
          // for testing
          fontFamily: font,
          // end for testing
          fontSize: 27.0,
          //fontWeight: FontWeight.w100,
        ),
        */
        style: GoogleFonts.getFont(
          font,
          textStyle: TextStyle(
            fontSize: 27.0,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}


