import 'bonus_stipulation.dart';
import 'team.dart';
import 'package:flutter/material.dart';

final highLowBasePoints = HighLowBasePoints();

class HighLowBasePoints implements BonusStipulation {
  @override
  int calculateBonus(Team team) {
    int lowPoints = 1000;
    int highPoints = 0;

    for (var player in team.hand) {
      if (player.points < lowPoints) lowPoints = player.points;
      if (player.points > highPoints) highPoints = player.points;
    }

    if (lowPoints == 1000) lowPoints = 0;

    debugPrint('bonus for HighLowBasePoints is ${lowPoints + highPoints}');
    return (lowPoints + highPoints);
  }
}
