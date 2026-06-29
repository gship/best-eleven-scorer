import 'color.dart';
import 'team.dart';
import 'package:flutter/material.dart';

class CardsOfColor {
  Color color;

  CardsOfColor(this.color);

  int cardsOfColor(Team team, {bool excludeKeeper = false}) {
    int numberOfCards = 0;
    for (var player in team.players) {
      if (player.color == color) {
        if (excludeKeeper) {
          if (player != team.keeper) {
            numberOfCards++;
          }
        } else {
          numberOfCards++;
        }
      }
    }

    debugPrint('there are $numberOfCards cards of color $color');
    return numberOfCards;
  }
}
