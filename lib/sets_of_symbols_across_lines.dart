import 'team.dart';
import 'bonus_stipulation.dart';
import 'player.dart';
import 'symbol.dart';
import 'multi_symbol_helper.dart';
import 'package:flutter/material.dart';

final setsOfSymbolsAcrossLines = SetsOfSymbolsAcrossLines();

class SetsOfSymbolsAcrossLines implements BonusStipulation {
  int bestSetCount = 0;

  @override
  int calculateBonus(Team team) {
    final int bonusPoints = 4;
    int sets = 0;
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
              allPlayerStats[playerM.index].trySymbol ==
                  allPlayerStats[playerD.index].trySymbol) {
            for (var playerF in team.forwards) {
              if (playersWithSingleSymbol.contains(playerF) &&
                  playersAvailable.contains(playerF) &&
                  allPlayerStats[playerF.index].trySymbol ==
                      allPlayerStats[playerD.index].trySymbol) {
                // found set; remove players from available list
                playersAvailable.remove(playerD);
                playersAvailable.remove(playerM);
                playersAvailable.remove(playerF);
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
    allPlayerStats[playersMultipleSymbols[i].index].trySymbol =
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
    int foundSets = 0;
    bool setFound = false;

    for (var playerD in team.defenders) {
      setFound = false;
      if (playersAvailable.contains(playerD) &&
          !playersInSets.contains(playerD)) {
        for (var playerM in team.midfielders) {
          if (playersAvailable.contains(playerM) &&
              !playersInSets.contains(playerM) &&
              allPlayerStats[playerM.index].trySymbol ==
                  allPlayerStats[playerD.index].trySymbol) {
            for (var playerF in team.forwards) {
              if (playersAvailable.contains(playerF) &&
                  !playersInSets.contains(playerF) &&
                  allPlayerStats[playerF.index].trySymbol ==
                      allPlayerStats[playerD.index].trySymbol) {
                playersInSets.add(playerD);
                playersInSets.add(playerM);
                playersInSets.add(playerF);
                debugPrint('found set with $playerD & $playerM & $playerF');
                foundSets++;
                setFound = true;
                break; // will continue at outer loop
              }
            }
            if (setFound) break; // will continue at outer loop
          }
        }
      }
    }

    return foundSets;
  }
}
