import 'player.dart';
import 'bonus_stipulation.dart';
import 'team.dart';
import 'package:flutter/material.dart';

final sameNumberOfEachKindOfSymbol = SameNumberOfEachKindOfSymbol();

class SameNumberOfEachKindOfSymbol implements BonusStipulation {
  @override
  int calculateBonus(Team team) {
    int totalSkills = 0;
    int totalSavvies = 0;
    int totalSpeeds = 0;
    int totalStrengths = 0;

    for (var p in team.players) {
      totalSkills += allPlayerStats[p.allPlayersIndex].numberOfSkills;
      totalSavvies += allPlayerStats[p.allPlayersIndex].numberOfSavvies;
      totalSpeeds += allPlayerStats[p.allPlayersIndex].numberOfSpeeds;
      totalStrengths += allPlayerStats[p.allPlayersIndex].numberOfStrengths;
    }

    debugPrint(
      'Totals symbols: skill=$totalSkills, savvy=$totalSavvies, speed=$totalSpeeds, strength=$totalStrengths',
    );

    bool allEqual =
        (totalSkills == totalSavvies) &&
        (totalSavvies == totalSpeeds) &&
        (totalSpeeds == totalStrengths);

    int ret = allEqual ? 25 : -7;
    debugPrint('bonus for SameNumberOfEachKindOfSymbol is $ret');
    return ret;
  }
}
