import 'package:best_eleven_scorer/player.dart';

import 'bonus_stipulation.dart';
import 'position.dart';
import 'team.dart';
import 'package:flutter/material.dart';

class AllPositionSamePointValue implements BonusStipulation {
  Position position;

  AllPositionSamePointValue(this.position);

  @override
  int calculateBonus(Team team) {
    bool first = true;
    int points = 0;
    bool allSamePointValue = true;

    for (var player in team.players) {
      if (allPlayerStats[player.index].playingPosition == position) {
        if (first) {
          points = player.points;
          first = false;
          continue;
        } else if (player.points != points) {
          allSamePointValue = false;
          break;
        }
      }
    }

    int ret = allSamePointValue ? 5 : 0;
    debugPrint('bonus for AllPositionSamePointValue is $ret');
    return ret;
  }
}
