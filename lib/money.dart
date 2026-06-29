import 'bonus_stipulation.dart';
import 'team.dart';
import 'package:flutter/material.dart';

final money = Money();

class Money implements BonusStipulation {
  @override
  int calculateBonus(Team team) {
    debugPrint('bonus for Money is ${team.money}');
    return team.money;
  }
}
