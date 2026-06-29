import 'package:best_eleven_scorer/player.dart';

import 'bonus_stipulation.dart';
import 'symbol.dart';
import 'team.dart';
import 'package:flutter/material.dart';

class ForEachSymbol implements BonusStipulation {
  Symbol symbol;

  ForEachSymbol(this.symbol);

  @override
  int calculateBonus(Team team) {
    int numberOfSymbol = 0;

    switch (symbol) {
      case Symbol.skill:
        for (var player in team.players) {
          numberOfSymbol += allPlayerStats[player.index].numberOfSkills;
        }

        break;

      case Symbol.savvy:
        for (var player in team.players) {
          numberOfSymbol += allPlayerStats[player.index].numberOfSavvies;
        }

        break;

      case Symbol.speed:
        for (var player in team.players) {
          numberOfSymbol += allPlayerStats[player.index].numberOfSpeeds;
        }

        break;

      case Symbol.strength:
        for (var player in team.players) {
          numberOfSymbol += allPlayerStats[player.index].numberOfStrengths;
        }

        break;
    }

    debugPrint('bonus for ForEachSymbol for $symbol is $numberOfSymbol');
    return numberOfSymbol;
  }
}
