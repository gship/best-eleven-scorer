import 'package:best_xi_scorer/team.dart';

import 'bonus_stipulation.dart';
import 'player.dart';
import 'symbol.dart';
import 'multi_symbol_helper.dart';
import 'package:flutter/material.dart';

final setsOfSymbolsAcrossLines = SetsOfSymbolsAcrossLines();

class SetsOfSymbolsAcrossLines implements BonusStipulation {
  int sets = 0;
  int bestSetCount = 0;

  @override
  int calculateBonus(Team team) {
    final int bonusPoints = 4;
    sets = 0;
    bestSetCount = 0;

    debugPrint('entering calculateBonus for SetsOfSymbolsAcrossLines');

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
    for (var playerD in team.defenders) {
      setFound = false;
      if (playersWithSingleSymbol.contains(playerD) &&
          playersAvailable.contains(playerD)) {
        for (var playerM in team.midfielders) {
          if (playersWithSingleSymbol.contains(playerM) &&
              playersAvailable.contains(playerM) &&
              playerM.trySymbol == playerD.trySymbol) {
            for (var playerF in team.forwards) {
              if (playersWithSingleSymbol.contains(playerF) &&
                  playersAvailable.contains(playerF) &&
                  playerF.trySymbol == playerD.trySymbol) {
                // found set; remove players from available list
                playersAvailable.remove(playerD);
                if (playersAvailable.contains(playerD)) {
                  debugPrint('failed to remove player playerD');
                }
                playersAvailable.remove(playerM);
                if (playersAvailable.contains(playerM)) {
                  debugPrint('failed to remove player playerM');
                }
                playersAvailable.remove(playerF);
                if (playersAvailable.contains(playerF)) {
                  debugPrint('failed to remove player playerF');
                }
                debugPrint('found set with $playerD & $playerM & $playerF');
                sets++;
                setFound = true;
                break; // will continue at outer loop
              }
            }
          }

          if (setFound) break; // will continue at outer loop
        }
      }
    }

    debugPrint(
      'there are ${playersMultipleSymbols.length} multi-symbol players',
    );
    if (playersMultipleSymbols.isNotEmpty) {
      /*      // the following loops are for debug only
      for (int i = 0; i < playersMultipleSymbols.length; ++i){
        debugPrint(playersMultipleSymbols[i].name);
        for (var symbol in playerTrySymbols[i]) {
          debugPrint('has symbol $symbol');
        }
      }
*/
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

    debugPrint(
      'bonus for SetsOfSymbolsAcrossLines is ${bonusPoints * (sets + bestSetCount)}',
    );
    return (bonusPoints * (sets + bestSetCount));
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

    for (var playerD in team.defenders) {
      setFound = false;
      if (playersAvailable.contains(playerD) &&
          !playersInSets.contains(playerD)) {
        for (var playerM in team.midfielders) {
          if (playersAvailable.contains(playerM) &&
              !playersInSets.contains(playerM) &&
              playerM.trySymbol == playerD.trySymbol) {
            for (var playerF in team.forwards) {
              if (playersAvailable.contains(playerF) &&
                  !playersInSets.contains(playerF) &&
                  playerF.trySymbol == playerD.trySymbol) {
                playersInSets.add(playerD);
                playersInSets.add(playerM);
                playersInSets.add(playerF);
                debugPrint('found set with $playerD & $playerM & $playerF');
                sets++;
                setFound = true;
                break; // will continue at outer loop
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
