import 'package:flutter/material.dart';

Widget backgroundContainer(BuildContext context, AssetImage backgroundImage, Widget content) {
  return Container(
    // Ensure the container fills the entire viewport
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(image: DecorationImage(image: backgroundImage, fit: BoxFit.cover)),
    child: Scaffold(backgroundColor: Colors.transparent, body: Center(child: SizedBox(height: 1000.0, width: 500.0, child: content))),
  );
}
