import 'bonus_stipulation.dart';
import 'team.dart';
import 'package:flutter/material.dart';

final noSymbols = NoSymbols();

class NoSymbols implements BonusStipulation {
  @override
  int calculateBonus(Team team) {
    final bonusPoints = 2;
    debugPrint('entering calculateBonus for NoSymbols');

    int noSymbolsCount = 0;
    for (var player in team.players) {
      // if the player has no symbols
      if (player.numberOfSkills == 0 &&
          player.numberOfSavvies == 0 &&
          player.numberOfSpeeds == 0 &&
          player.numberOfStrengths == 0 &&
          player.chosenSymbol == null) {
        debugPrint(
          'player ${player.name} #skills = ${player.numberOfSkills}, #savvies = ${player.numberOfSavvies}, #speeds = ${player.numberOfSpeeds}, #strengths = ${player.numberOfStrengths}, chosenSymbol = ${player.chosenSymbol}',
        );
        noSymbolsCount++;
      }
    }

    debugPrint('bonus for NoSymbols is ${bonusPoints * noSymbolsCount}');
    return (bonusPoints * noSymbolsCount);
  }
}
