import 'package:flutter/material.dart';

Widget mainContain(
  BuildContext context,
  AssetImage backgroundImage,
  Widget content,
  bool setBackgroundColor,
  bool repeatImage,
) {
  return Scaffold(
    backgroundColor: setBackgroundColor ? Colors.black : null,
    resizeToAvoidBottomInset: false,
    body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: backgroundImage,
          repeat: repeatImage ? ImageRepeat.repeat : ImageRepeat.noRepeat,
        ),
      ),
      child: Center(
        child: Container(
          height: 1000.0,
          width: 500.0,
          child: content,
        ),
      ),
    ),
  );
}
