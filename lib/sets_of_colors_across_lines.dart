import 'team.dart';
import 'package:flutter/material.dart';
import 'bonus_stipulation.dart';
import 'player.dart';

final setsOfColorsAcrossLines = SetsOfColorsAcrossLines();

class SetsOfColorsAcrossLines implements BonusStipulation {
  int bestSetCount = 0;

  @override
  int calculateBonus(Team team) {
    debugPrint('entering calculateBonus for SetsOfColorsAcrossLines');
    // 5 FOR 1, 15 FOR 2

    bestSetCount = 0;

    bestSetCount = setsOfColor(team);

    int retValue = 0;
    if (bestSetCount >= 2) {
      retValue = 15;
    } else if (bestSetCount >= 1) {
      retValue = 5;
    }
    debugPrint('bonus for SetsOfColorsAcrossLines is $retValue');
    return retValue;
  }

  int setsOfColor(Team team) {
    List<Player> playersInSets = List.empty(growable: true);
    int sets = 0;
    bool setFound = false;

    for (var playerD in team.defenders) {
      setFound = false;
      if (!playersInSets.contains(playerD)) {
        for (var playerM in team.midfielders) {
          if (!playersInSets.contains(playerM) &&
              playerM.color == playerD.color) {
            for (var playerF in team.forwards) {
              if (!playersInSets.contains(playerF) &&
                  playerF.color == playerD.color) {
                playersInSets.add(playerD);
                playersInSets.add(playerM);
                playersInSets.add(playerF);
                debugPrint('found set with $playerD & $playerM & $playerF');
                sets++;
                setFound = true;
                break;
              }
            }
            if (setFound) break;
          }
        }
      }
    }

    return sets;
  }
}
