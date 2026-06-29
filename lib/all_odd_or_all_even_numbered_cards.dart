import 'bonus_stipulation.dart';
import 'team.dart';
import 'package:flutter/material.dart';

final allOddOrAllEvenNumberedCards = AllOddOrAllEvenNumberedCards();

class AllOddOrAllEvenNumberedCards implements BonusStipulation {
  @override
  int calculateBonus(Team team) {
    bool hasOddCards = false;
    bool hasEvenCards = false;

    for (var player in team.players) {
      if (player.index % 2 == 0) {
        hasEvenCards = true;
      } else {
        hasOddCards = true;
      }
    }

    bool hasAllOddOrEvenCards =
        (hasOddCards && !hasEvenCards) || (hasEvenCards && !hasOddCards);

    int ret = (hasAllOddOrEvenCards) ? 20 : -5;
    debugPrint('bonus for AllOddOrAllEvenNumberedCards is $ret');
    return ret;
  }
}
