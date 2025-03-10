import 'bonus_stipulation.dart';
import 'team.dart';
import 'package:flutter/material.dart';

final playerBasePoints = PlayerBasePoints();

class PlayerBasePoints implements BonusStipulation {
  @override
  int calculateBonus(Team team) {
    debugPrint('entering calculateBonus for PlayerBonusPoints');
    int returnPoints = 0;

    for (var player in team.players) {
      //debugPrint('${player.name} has ${player.points} points');
      returnPoints += player.points;
    }

    debugPrint('bonus for PlayerBonusPoints is $returnPoints');
    return returnPoints;
  }
}
