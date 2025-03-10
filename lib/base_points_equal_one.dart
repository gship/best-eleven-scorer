import 'bonus_stipulation.dart';
import 'team.dart';
import 'package:flutter/material.dart';

final basePointsEqualOne = BasePointsEqualOne();

class BasePointsEqualOne implements BonusStipulation {
  @override
  int calculateBonus(Team team) {
    debugPrint('entering calculateBonus for BasePointsEqualOne');
    // 4 IF 3-4CARDS, 7 IF 5+CARDS

    int count = 0;
    for (var player in team.players) {
      if (player.points == 1) count++;
    }

    int retValue = 0;
    if (count >= 5) {
      retValue = 7;
    } else if (count >= 3) {
      retValue = 4;
    }
    debugPrint('bonus for BasePointsEqualOne is $retValue');
    return retValue;
  }
}
