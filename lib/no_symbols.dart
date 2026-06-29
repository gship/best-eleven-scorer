import 'package:best_eleven_scorer/player.dart';

import 'bonus_stipulation.dart';
import 'team.dart';
import 'package:flutter/material.dart';

final noSymbols = NoSymbols();

class NoSymbols implements BonusStipulation {
  @override
  int calculateBonus(Team team) {
    int retVal = 0;

    int noSymbolsCount = 0;
    for (var player in team.players) {
      // if the player has no symbols
      if (allPlayerStats[player.index].numberOfSkills == 0 &&
          allPlayerStats[player.index].numberOfSavvies == 0 &&
          allPlayerStats[player.index].numberOfSpeeds == 0 &&
          allPlayerStats[player.index].numberOfStrengths == 0) {
        noSymbolsCount++;
      }
    }

    retVal = 2 * noSymbolsCount;

    debugPrint('bonus for NoSymbols is $retVal');
    return retVal;
  }
}
