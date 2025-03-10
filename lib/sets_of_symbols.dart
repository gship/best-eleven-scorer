import 'package:best_xi_scorer/team.dart';

import 'bonus_stipulation.dart';
import 'player.dart';
import 'symbol.dart';
import 'multi_symbol_helper.dart';
import 'package:flutter/material.dart';

final setsOfSymbols = SetsOfSymbols();

class SetsOfSymbols implements BonusStipulation {
  int bestSetCount = 0;
  int sets = 0;

  @override
  int calculateBonus(Team team) {
    int retVal = 0;
    bestSetCount = 0;
    sets = 0;
    debugPrint('entering calculateBonus for SetsOfSymbols');

    List<Player> playersMultipleSymbols = List.empty(growable: true);
    List<Player> playersWithSingleSymbol = List.empty(growable: true);
    List<List<Symbol>> playerTrySymbols = List.empty(
      growable: true,
    ); // the multiple symbols
    List<int> playerSelectIndexes = List.empty(
      growable: true,
    ); // the index of the multiple symbol being tried
    List<Player> playersAvailable = List.empty(growable: true);

    MultiSymbolHelper.constructMultipleSymbolPlayerList(
      team.players,
      playersMultipleSymbols,
      playersWithSingleSymbol,
      playerSelectIndexes,
      playerTrySymbols,
      playersAvailable,
    );

    bool setFound = false;
    for (var playerSk in playersWithSingleSymbol) {
      setFound = false;
      if (playersAvailable.contains(playerSk) &&
          playerSk.trySymbol == Symbol.skill) {
        for (var playerSa in playersWithSingleSymbol) {
          if (playersAvailable.contains(playerSa) &&
              playerSa.trySymbol == Symbol.savvy) {
            for (var playerSp in playersWithSingleSymbol) {
              if (playersAvailable.contains(playerSp) &&
                  playerSp.trySymbol == Symbol.speed) {
                for (var playerSt in playersAvailable) {
                  if (playersAvailable.contains(playerSt) &&
                      playerSt.trySymbol == Symbol.strength) {
                    // found a set; remove players from available list
                    playersAvailable.remove(playerSk);
                    if (playersAvailable.contains(playerSk)) {
                      debugPrint('failed to remove player playerSk');
                    }
                    playersAvailable.remove(playerSa);
                    if (playersAvailable.contains(playerSa)) {
                      debugPrint('failed to remove player playerSa');
                    }
                    playersAvailable.remove(playerSp);
                    if (playersAvailable.contains(playerSp)) {
                      debugPrint('failed to remove player playerSp');
                    }
                    playersAvailable.remove(playerSt);
                    if (playersAvailable.contains(playerSt)) {
                      debugPrint('failed to remove player playerSt');
                    }
                    debugPrint(
                      'found set with $playerSk & $playerSa & $playerSp & $playerSt',
                    );
                    sets++;
                    setFound = true;
                    break; // will continue at outer loop
                  }
                }
                if (setFound) break; // will continue at outer loop
              }
            }
            if (setFound) break; // will continue at outer loop
          }
        }
      }
    }

    if (playersMultipleSymbols.isNotEmpty) {
      int i = 0;
      recurseFindSets(
        i,
        team,
        playersMultipleSymbols,
        playerSelectIndexes,
        playersWithSingleSymbol,
        playersAvailable,
        playerTrySymbols,
      );
    }

    sets += bestSetCount;

    if (sets == 1) {
      retVal = 4;
    } else if (sets == 2) {
      retVal = 15;
    }

    debugPrint('bonus for SetsOfSymbols is $retVal');
    return retVal;
  }

  void recurseFindSets(
    int i,
    Team team,
    List<Player> playersMultipleSymbols,
    List<int> playerSelectIndexes,
    List<Player> playersWithSingleSymbol,
    List<Player> playersAvailable,
    List<List<Symbol>> playerTrySymbols,
  ) {
    debugPrint(
      'recurseFindSets - i = $i, index = ${playerSelectIndexes[i]}, ${playersMultipleSymbols[i]} trySymbol = ${playerTrySymbols[i][playerSelectIndexes[i]]}',
    );
    playersMultipleSymbols[i].trySymbol =
        playerTrySymbols[i][playerSelectIndexes[i]];

    // if more players with multiple symbols
    if (i < playersMultipleSymbols.length - 1) {
      recurseFindSets(
        i + 1,
        team,
        playersMultipleSymbols,
        playerSelectIndexes,
        playersWithSingleSymbol,
        playersAvailable,
        playerTrySymbols,
      );
    } else {
      // all players with multiple symbols have been assigned a try symbol
      int setCount = findSets(team, playersAvailable);
      if (setCount > bestSetCount) {
        bestSetCount = setCount;
        debugPrint('....... best set count = $bestSetCount .......');
      }
    }

    // if this player has more symbols to try
    if (playerSelectIndexes[i] < (playerTrySymbols[i].length - 1)) {
      playerSelectIndexes[i]++;
      recurseFindSets(
        i,
        team,
        playersMultipleSymbols,
        playerSelectIndexes,
        playersWithSingleSymbol,
        playersAvailable,
        playerTrySymbols,
      );
    } else {
      playerSelectIndexes[i] =
          0; // reset so on next iteration will start at first of multiple symbols
    }
  }

  int findSets(Team team, List<Player> playersAvailable) {
    List<Player> playersInSets = List.empty(growable: true);
    int sets = 0;
    bool setFound = false;

    for (var playerSk in playersAvailable) {
      setFound = false;
      if (playersAvailable.contains(playerSk) &&
          !playersInSets.contains(playerSk) &&
          playerSk.trySymbol == Symbol.skill) {
        for (var playerSa in playersAvailable) {
          if (playersAvailable.contains(playerSa) &&
              !playersInSets.contains(playerSa) &&
              playerSa.trySymbol == Symbol.savvy) {
            for (var playerSp in playersAvailable) {
              if (playersAvailable.contains(playerSp) &&
                  !playersInSets.contains(playerSp) &&
                  playerSp.trySymbol == Symbol.speed) {
                for (var playerSt in playersAvailable) {
                  if (playersAvailable.contains(playerSt) &&
                      !playersInSets.contains(playerSt) &&
                      playerSt.trySymbol == Symbol.strength) {
                    playersInSets.add(playerSk);
                    playersInSets.add(playerSa);
                    playersInSets.add(playerSp);
                    playersInSets.add(playerSt);
                    debugPrint(
                      'found set with $playerSk & $playerSa & $playerSp & $playerSt',
                    );
                    sets++;
                    setFound = true;
                    break; // will continue at outer loop
                  }
                }
                if (setFound) break; // will continue at outer loop
              }
            }
            if (setFound) break; // will continue at outer loop
          }
        }
      }
    }

    return sets;
  }
}
