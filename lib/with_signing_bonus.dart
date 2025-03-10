import 'bonus_stipulation.dart';
import 'team.dart';
import 'package:flutter/material.dart';

final withSigningBonus = WithSigningBonus();

class WithSigningBonus implements BonusStipulation {
  @override
  int calculateBonus(Team team) {
    debugPrint('entering calculateBonus for WithSigningBonus');
    // 3 IF 4-5CARDS, 6 IF 6+CARDS

    int count = 0;
    for (var player in team.players) {
      if (player.hasSigningBonus) count++;
    }

    int retValue = 0;
    if (count >= 6) {
      retValue = 6;
    } else if (count >= 4) {
      retValue = 3;
    }
    debugPrint('bonus for WithSigningBonus is $retValue');
    return retValue;
  }
}
