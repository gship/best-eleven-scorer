import 'package:flutter/material.dart';

const List<Symbol> allSymbols = <Symbol>[
  Symbol.skill,
  Symbol.savvy,
  Symbol.speed,
  Symbol.strength,
];

enum Symbol { skill, savvy, speed, strength }

Image? symbolImage(Symbol? symbol) {
  switch (symbol) {
    case null:
      return (null);
    case Symbol.skill:
      return (Image.asset(
        'images/skill.png',
        width: 16,
        height: 16,
        fit: BoxFit.cover,
      ));
    case Symbol.savvy:
      return (Image.asset(
        'images/savvy.png',
        width: 16,
        height: 16,
        fit: BoxFit.cover,
      ));
    case Symbol.speed:
      return (Image.asset(
        'images/speed.png',
        width: 16,
        height: 16,
        fit: BoxFit.cover,
      ));
    case Symbol.strength:
      return (Image.asset(
        'images/strength.png',
        width: 16,
        height: 16,
        fit: BoxFit.cover,
      ));
  }
}

String symbolToText(Symbol? symbol) {
  switch (symbol) {
    case null:
      return ('');
    case Symbol.skill:
      return ('\u2B50');
    case Symbol.savvy:
      return ('\u1F9E0');
    case Symbol.speed:
      return ('\u26A1');
    case Symbol.strength:
      return ('\u2764');
  }
}
