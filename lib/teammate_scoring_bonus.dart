import 'package:best_eleven_scorer/player.dart';

import 'team.dart';
import 'package:flutter/material.dart';
import 'bonus_stipulation.dart';
import 'color.dart';
import 'position.dart';

class TeammateScoringBonus implements BonusStipulation {
  final Color color;
  final Position position;

  const TeammateScoringBonus(this.color, this.position);

  @override
  int calculateBonus(Team team) {
    bool found = findTeammate(team);

    // 5 if found
    int retValue = 0;
    if (found) {
      retValue = 5;
    }
    debugPrint('bonus for TeammateScoringBonus is $retValue');
    return retValue;
  }

  bool findTeammate(Team team) {
    bool found = false;

    for (var player in team.players) {
      if (player.color == color &&
          allPlayerStats[player.index].playingPosition == position) {
        found = true;
        break;
      }
    }

    return found;
  }
}
