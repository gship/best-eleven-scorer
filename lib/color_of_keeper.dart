import 'package:best_xi_scorer/cards_of_color.dart';

import 'bonus_stipulation.dart';
import 'color.dart';
import 'team.dart';
import 'package:flutter/material.dart';

class ColorOfKeeper implements BonusStipulation {
  ColorOfKeeper();

  @override
  int calculateBonus(Team team) {
    Color color = team.keeper!.color;
    debugPrint(
      'entering calculateBonus for ColorOfKeeper for keeper = ${team.keeper!.name}, color = $color',
    );
    int retVal = 0;
    int numberOfCards = CardsOfColor(
      color,
    ).cardsOfColor(team, excludeKeeper: true);
    debugPrint('found $numberOfCards with matching color');

    retVal = numberOfCards * 2;
    debugPrint('bonus for ColorOfKeeper for color $color is $retVal');
    return retVal;
  }
}
