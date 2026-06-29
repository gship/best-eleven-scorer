import 'bonus_stipulation.dart';
import 'team.dart';
import 'package:flutter/material.dart';

final allCardsTheSamePoints = AllCardsTheSamePoints();

class AllCardsTheSamePoints implements BonusStipulation {
  @override
  int calculateBonus(Team team) {
    bool first = true;
    bool allTheSame = true;
    int points = 0;
    for (var player in team.players) {
      if (first) {
        first = false;
        points = player.points;
      } else if (player.points != points) {
        allTheSame = false;
        break;
      }
    }

    int ret = allTheSame ? 25 : -7;
    debugPrint('bonus for AllCardsTheSamePoints is $ret');
    return ret;
  }
}
