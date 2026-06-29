import 'package:best_eleven_scorer/core.dart';

import 'cards_of_color.dart';

import 'bonus_stipulation.dart';
import 'color.dart';
import 'team.dart';
import 'package:flutter/material.dart';

class MoreCardsOfColorThanAnyOtherPlayerColor implements BonusStipulation {
  final Color color;

  MoreCardsOfColorThanAnyOtherPlayerColor(this.color);

  @override
  int calculateBonus(Team team) {
    int returnPoints = 0;
    int numberOfCards = CardsOfColor(color).cardsOfColor(team);
    bool hasMoreOfColor = true;

    if (core.numPlayers == 1 && !core.playingSolo) {
      if (team.moreColor[color] == true) {
        hasMoreOfColor = true;
      }
    } else {
      for (var otherTeam in teams) {
        if (otherTeam != team) {
          if (CardsOfColor(color).cardsOfColor(otherTeam) >= numberOfCards) {
            hasMoreOfColor = false;
            break;
          }
        }
      }
    }

    // 6 IF TWO PLAYERS, 9 IF THREE PLAYERS, 12 IF FOUR PLAYERS
    if (hasMoreOfColor) {
      if (teams.length == 2) {
        returnPoints = 6;
      } else if (teams.length == 3) {
        returnPoints = 9;
      } else if (teams.length == 4) {
        returnPoints = 12;
      }
    }

    debugPrint(
      'bonus for MoreCardsOfColorThanAnyOtherPlayerColor for color $color is $returnPoints',
    );
    return returnPoints;
  }
}
