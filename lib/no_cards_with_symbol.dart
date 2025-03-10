import 'bonus_stipulation.dart';
import 'symbol.dart';
import 'team.dart';
import 'package:flutter/material.dart';

class NoCardsWithSymbol implements BonusStipulation {
  Symbol symbol;

  NoCardsWithSymbol(this.symbol);

  @override
  int calculateBonus(Team team) {
    debugPrint(
      'entering calculateBonus for NoCardsWithSymbol for symbol = $symbol',
    );
    int returnPoints = 0;

    int numberOfCards = 0;

    switch (symbol) {
      case Symbol.skill:
        for (var player in team.players) {
          if (player.numberOfSkills > 0) {
            numberOfCards++;
          } else if (player.chosenSymbol == Symbol.skill) {
            numberOfCards++;
          }
        }

        break;

      case Symbol.savvy:
        for (var player in team.players) {
          if (player.numberOfSavvies > 0) {
            numberOfCards++;
          } else if (player.chosenSymbol == Symbol.savvy) {
            numberOfCards++;
          }
        }

        break;

      case Symbol.speed:
        for (var player in team.players) {
          if (player.numberOfSpeeds > 0) {
            numberOfCards++;
          } else if (player.chosenSymbol == Symbol.speed) {
            numberOfCards++;
          }
        }

        break;

      case Symbol.strength:
        for (var player in team.players) {
          if (player.numberOfStrengths > 0) {
            numberOfCards++;
          } else if (player.chosenSymbol == Symbol.strength) {
            numberOfCards++;
          }
        }

        break;
    }

    if (numberOfCards == 0) {
      returnPoints = 7;
    }

    debugPrint(
      'bonus for NoCardsWithSymbol for symbol = $symbol is $returnPoints',
    );
    return returnPoints;
  }
}
