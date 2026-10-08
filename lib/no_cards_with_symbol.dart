import 'player.dart';

import 'bonus_stipulation.dart';
import 'symbol.dart';
import 'team.dart';
import 'package:flutter/material.dart';

class NoCardsWithSymbol implements BonusStipulation {
  Symbol symbol;

  NoCardsWithSymbol(this.symbol);

  @override
  int calculateBonus(Team team) {
    int retVal = 0;

    bool symbolFound = false;

    switch (symbol) {
      case Symbol.skill:
        for (var player in team.players) {
          if (allPlayerStats[player.allPlayersIndex].numberOfSkills > 0) {
            symbolFound = true;
            break;
          }
        }

        break;

      case Symbol.savvy:
        for (var player in team.players) {
          if (allPlayerStats[player.allPlayersIndex].numberOfSavvies > 0) {
            symbolFound = true;
            break;
          }
        }

        break;

      case Symbol.speed:
        for (var player in team.players) {
          if (allPlayerStats[player.allPlayersIndex].numberOfSpeeds > 0) {
            symbolFound = true;
            break;
          }
        }

        break;

      case Symbol.strength:
        for (var player in team.players) {
          if (allPlayerStats[player.allPlayersIndex].numberOfStrengths > 0) {
            symbolFound = true;
            break;
          }
        }

        break;
    }

    if (!symbolFound) {
      retVal = 7;
    }

    debugPrint('bonus for NoCardsWithSymbol for symbol = $symbol is $retVal');
    return retVal;
  }
}
