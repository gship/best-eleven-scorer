import 'package:best_xi_scorer/cards_of_color.dart';

import 'bonus_stipulation.dart';
import 'color.dart';
import 'team.dart';
import 'package:flutter/material.dart';

class CardsWithColor implements BonusStipulation {
  Color color;

  CardsWithColor(this.color);

  @override
  int calculateBonus(Team team) {
    debugPrint('entering calculateBonus for CardsWithColor for color = $color');
    int returnPoints = 0;
    int numberOfCards = CardsOfColor(color).cardsOfColor(team);
    debugPrint('found $numberOfCards with color $color');

    // 4 IF 3-4CARDS, 7 IF 5+CARDS
    // tacCards return per below
    if (numberOfCards >= 5) {
      returnPoints = 7;
    } else if (numberOfCards >= 3) {
      returnPoints = 4;
    } else {
      returnPoints = 0;
    }

    debugPrint('bonus for CardsWithColor for color $color is $returnPoints');
    return returnPoints;
  }
}
