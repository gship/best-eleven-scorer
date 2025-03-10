import 'package:best_xi_scorer/team.dart';

import 'bonus_stipulation.dart';
import 'player.dart';
import 'color.dart';
import 'package:flutter/material.dart';

final setsOfColors = SetsOfColors();

class SetsOfColors implements BonusStipulation {
  int bestSetCount = 0;

  @override
  int calculateBonus(Team team) {
    int retVal = 0;
    debugPrint('entering calculateBonus for SetsOfColors');

    bestSetCount = setsOfColor(team);

    if (bestSetCount == 1) {
      retVal = 5;
    } else if (bestSetCount == 2) {
      retVal = 12;
    }

    debugPrint('bonus for SetsOfColors is $retVal');
    return retVal;
  }

  int setsOfColor(Team team) {
    List<Player> playersInSets = List.empty(growable: true);
    int sets = 0;
    bool setFound = false;

    for (var playerY in team.players) {
      setFound = false;
      if (playerY.color == Color.yellow && !playersInSets.contains(playerY)) {
        for (var playerT in team.players) {
          if (playerT.color == Color.teal && !playersInSets.contains(playerT)) {
            for (var playerO in team.players) {
              if (playerO.color == Color.orange &&
                  !playersInSets.contains(playerO)) {
                for (var playerR in team.players) {
                  if (playerR.color == Color.red &&
                      !playersInSets.contains(playerR)) {
                    for (var playerP in team.players) {
                      if (playerP.color == Color.purple &&
                          !playersInSets.contains(playerP)) {
                        playersInSets.add(playerY);
                        playersInSets.add(playerT);
                        playersInSets.add(playerO);
                        playersInSets.add(playerR);
                        playersInSets.add(playerP);
                        debugPrint(
                          'found set with $playerY & $playerT & $playerO & $playerR & $playerP',
                        );
                        sets++;
                        setFound = true;
                        break;
                      }
                    }
                    if (setFound) break;
                  }
                }
                if (setFound) break;
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
