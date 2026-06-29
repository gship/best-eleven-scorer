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
        'images/skill.webp',
        width: 16,
        height: 16,
        fit: BoxFit.cover,
      ));
    case Symbol.savvy:
      return (Image.asset(
        'images/savvy.webp',
        width: 16,
        height: 16,
        fit: BoxFit.cover,
      ));
    case Symbol.speed:
      return (Image.asset(
        'images/speed.webp',
        width: 16,
        height: 16,
        fit: BoxFit.cover,
      ));
    case Symbol.strength:
      return (Image.asset(
        'images/strength.webp',
        width: 16,
        height: 16,
        fit: BoxFit.cover,
      ));
  }
}
