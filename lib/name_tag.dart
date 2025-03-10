import 'package:flutter/material.dart';

Align nameTag(String name) => Align(
  alignment: Alignment.centerLeft,
  child: Text(
    name,
    style: TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontFamily: 'Providence',
      fontWeight: FontWeight.bold,
    ),
  ),
);
