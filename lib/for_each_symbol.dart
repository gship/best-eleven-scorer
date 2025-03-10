import 'bonus_stipulation.dart';
import 'symbol.dart';
import 'team.dart';
import 'package:flutter/material.dart';

class ForEachSymbol implements BonusStipulation {
  Symbol symbol;

  ForEachSymbol(this.symbol);

  @override
  int calculateBonus(Team team) {
    final int bonusPoints = 1;

    debugPrint('entering calculateBonus for ForEachSymbol for $symbol');

    int numberOfSymbol = 0;

    switch (symbol) {
      case Symbol.skill:
        for (var player in team.players) {
          numberOfSymbol += player.numberOfSkills;
          if (player.chosenSymbol == Symbol.skill) {
            numberOfSymbol++;
          }
        }

        break;

      case Symbol.savvy:
        for (var player in team.players) {
          numberOfSymbol += player.numberOfSavvies;
          if (player.chosenSymbol == Symbol.savvy) {
            numberOfSymbol++;
          }
        }

        break;

      case Symbol.speed:
        for (var player in team.players) {
          numberOfSymbol += player.numberOfSpeeds;
          if (player.chosenSymbol == Symbol.speed) {
            numberOfSymbol++;
          }
        }

        break;

      case Symbol.strength:
        for (var player in team.players) {
          numberOfSymbol += player.numberOfStrengths;
          if (player.chosenSymbol == Symbol.strength) {
            numberOfSymbol++;
          }
        }

        break;
    }

    debugPrint(
      'bonus for ForEachSymbol for $symbol is ${bonusPoints * numberOfSymbol}',
    );
    return (bonusPoints * numberOfSymbol);
  }
}
