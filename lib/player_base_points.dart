import 'bonus_stipulation.dart';
import 'team.dart';
import 'player.dart';
import 'package:flutter/material.dart';

final playerBasePoints = PlayerBasePoints();

class PlayerBasePoints implements BonusStipulation {
  @override
  int calculateBonus(Team team) {
    int retVal = 0;

    for (var player in team.players) {
      if (player.points == -1) {
        debugPrint(
          'Player ${player.name} form match ----------------------------',
        );
        retVal += formMatch(team, player);
      } else {
        retVal += player.points;
      }

      if (player.pointsScoringBonus != null) {
        debugPrint(
          'Player ${player.name} bonus stipulation ${player.pointsScoringBonus} ----------------------------',
        );
        retVal += player.pointsScoringBonus!.calculateBonus(team);
      }
    }

    debugPrint('bonus for PlayerBonusPoints is $retVal');
    return retVal;
  }

  int formMatch(Team team, Player player) {
    int highPoints = 0;
    for (var mate in team.players) {
      if (allPlayerStats[mate.index].playingPosition ==
          allPlayerStats[player.index].playingPosition) {
        if (mate.points > highPoints) {
          highPoints = mate.points;
        }
      }
    }

    if (highPoints == 0) {
      highPoints = 2;
    }

    return highPoints;
  }
}
