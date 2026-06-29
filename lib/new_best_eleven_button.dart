import 'package:flutter/material.dart';

class NewBestElevenButton extends StatelessWidget {
  const NewBestElevenButton({
    required this.buttonText,
    required this.onPressed,
    super.key,
  });

  final void Function()? onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    double elevation = 27.0;
    WidgetStateProperty<double>? elevationValue;
    elevationValue =
        WidgetStateProperty<double>.fromMap(<WidgetStatesConstraint, double>{
          WidgetState.disabled: 27,
          WidgetState.pressed: elevation + 6,
          WidgetState.hovered: elevation + 2,
          WidgetState.focused: elevation + 2,
          WidgetState.any: elevation,
        });

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.fromLTRB(20, 9, 20, 10)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          minimumSize: const WidgetStatePropertyAll(Size(100, 60)),
          backgroundColor: WidgetStateProperty.all(Colors.black),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          overlayColor: WidgetStatePropertyAll<Color>(Colors.pink),
          shadowColor: WidgetStateProperty.all(Colors.black),
          elevation: elevationValue, // Set the initial elevation to 0
        ),
        onPressed: onPressed,
        child: Text(buttonText, style: TextStyle(fontSize: 20.0)),
      ),
    );
  }
}
