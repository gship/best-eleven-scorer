import 'bonus_stipulation.dart';
import 'color.dart';
import 'team.dart';
import 'package:flutter/material.dart';

final onlyTwoColors = OnlyTwoColors();

class OnlyTwoColors implements BonusStipulation {
  @override
  int calculateBonus(Team team) {
    bool hasOnlyTwoColors = true;
    bool first = true;
    bool second = true;
    Color firstColor = Color.yellow;
    Color secondColor = Color.yellow;

    for (var player in team.players) {
      if (first) {
        firstColor = player.color;
        first = false;
        continue;
      } else if (second) {
        secondColor = player.color;
        second = false;
      } else if (player.color != firstColor && player.color != secondColor) {
        hasOnlyTwoColors = false;
        break;
      }
    }

    int ret = hasOnlyTwoColors ? 25 : -5;
    debugPrint('bonus for OnlyTwoColors is $ret');
    return ret;
  }
}
