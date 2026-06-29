import 'team.dart';

import 'bonus_stipulation.dart';
import 'player.dart';
import 'symbol.dart';
import 'multi_symbol_helper.dart';
import 'package:flutter/material.dart';

final onlyOneKindOfSymbol = OnlyOneKindOfSymbol();

class OnlyOneKindOfSymbol implements BonusStipulation {
  int bestSetCount = 0;

  @override
  int calculateBonus(Team team) {
    debugPrint('entering calculateBonus for OnlyOneKindOfSymbol');

    List<Player> playersWithMultipleSymbols = List.empty(growable: true);
    List<Player> playersWithSingleSymbol = List.empty(growable: true);
    // the list of the multiple symbols
    List<List<Symbol>> playerMultipleSymbols = List.empty(growable: true);
    // the index of the multiple symbol being tried
    List<int> playerMultipleSymbolsIndex = List.empty(growable: true);
    List<Player> playersAvailable = List.empty(growable: true);

    MultiSymbolHelper.constructMultipleSymbolPlayerList(
      team.players,
      playersWithMultipleSymbols,
      playersWithSingleSymbol,
      playerMultipleSymbolsIndex,
      playerMultipleSymbols,
      playersAvailable,
    );

    bool hasOnlyOneKindOfSymbol = true;

    if (playersWithMultipleSymbols.isNotEmpty) {
      hasOnlyOneKindOfSymbol = false;
    } else {
      // check that all players with a symbol have the same symbol
      bool first = true;
      Symbol? symbol;
      for (var player in playersWithSingleSymbol) {
        if (first) {
          symbol = getPlayerSymbol(player);
          first = false;
        } else if (getPlayerSymbol(player) != symbol) {
          hasOnlyOneKindOfSymbol = false;
          break;
        }
      }
    }

    int ret = hasOnlyOneKindOfSymbol ? 25 : -7;
    debugPrint('bonus for OnlyOneKindOfSymbol is $ret');
    return ret;
  }
}

Symbol getPlayerSymbol(Player player) {
  if (allPlayerStats[player.index].numberOfSkills > 0) {
    return Symbol.skill;
  } else if (allPlayerStats[player.index].numberOfSavvies > 0) {
    return Symbol.savvy;
  } else if (allPlayerStats[player.index].numberOfSpeeds > 0) {
    return Symbol.speed;
  } else if (allPlayerStats[player.index].numberOfStrengths > 0) {
    return Symbol.strength;
  } else {
    throw Exception('Player ${player.name} has no symbols');
  }
}
