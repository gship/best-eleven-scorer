import 'bonus_stipulation.dart';
import 'team.dart';
import 'package:flutter/material.dart';

final theInTheName = TheInTheName();

class TheInTheName implements BonusStipulation {
  @override
  int calculateBonus(Team team) {
    int count = 0;
    for (var player in team.players) {
      if (player.hasTheInName) {
        count++;
      }
    }

    // 3 IF 3-4CARDS, 5 IF 5+CARDS
    int retValue = 0;
    if (count >= 5) {
      retValue = 5;
    } else if (count >= 3) {
      retValue = 3;
    }
    debugPrint('bonus for TheInTheName is $retValue');
    return retValue;
  }
}
