import 'bonus_stipulation.dart';
import 'team.dart';
import 'package:flutter/material.dart';

final money = Money();

class Money implements BonusStipulation {
  @override
  int calculateBonus(Team team) {
    final int bonusPoints = 1;
    debugPrint('entering calculateBonus for Money');
    debugPrint('bonus for Money is ${bonusPoints * team.money}');
    return (bonusPoints * team.money);
  }
}
