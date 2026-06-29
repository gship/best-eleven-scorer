import 'bonus_stipulation.dart';
import 'team.dart';
import 'package:flutter/material.dart';

final multiplePositions = MultiplePositions();

class MultiplePositions implements BonusStipulation {
  @override
  int calculateBonus(Team team) {
    int count = 0;
    int multiCount = 0;
    for (var player in team.players) {
      multiCount = 0;
      if (player.isDefender) multiCount++;
      if (player.isMid) multiCount++;
      if (player.isForward) multiCount++;
      if (multiCount > 1) count++;
    }

    // 3 IF 3-4CARDS, 6 IF 5+CARDS
    int retValue = 0;
    if (count >= 5) {
      retValue = 6;
    } else if (count >= 3) {
      retValue = 3;
    }
    debugPrint('bonus for MultiplePositions is $retValue');
    return retValue;
  }
}
