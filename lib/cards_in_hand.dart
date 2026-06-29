import 'bonus_stipulation.dart';
import 'team.dart';
import 'package:flutter/material.dart';

final cardsInHand = CardsInHand();

class CardsInHand implements BonusStipulation {
  @override
  int calculateBonus(Team team) {
    // 5 IF 3CARDS, 8 IF 4+CARDS
    int retValue = 0;
    if (team.hand.length >= 4) {
      retValue = 7;
    } else if (team.hand.length >= 3) {
      retValue = 5;
    }
    debugPrint('bonus for CardsInHand is $retValue');
    return retValue;
  }
}
