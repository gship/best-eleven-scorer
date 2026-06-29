import 'team.dart';

import 'bonus_stipulation.dart';
import 'player.dart';
import 'symbol.dart';
import 'multi_symbol_helper.dart';
import 'package:flutter/material.dart';

final setsOfSymbols = SetsOfSymbols();

class SetsOfSymbols implements BonusStipulation {
  int bestSetCount = 0;

  @override
  int calculateBonus(Team team) {
    int retVal = 0;
    bestSetCount = 0;
    int sets = 0;

    List<Player> playersWithMultipleSymbols = List.empty(growable: true);
    List<Player> playersWithSingleSymbol = List.empty(growable: true);
    // the multiple symbols of a player with multiple symbols, outer list index is player, inner list index is 0 through number of symbols -1
    // the inner list index is kept track of in playerMultipleSymbolsIndex
    List<List<Symbol>> playerMultipleSymbols = List.empty(growable: true);
    // the index of the symbol from playerMultipleSymbols that is to be tried, list index is the player index from playersWithMultipleSymbols
    List<int> playerMultipleSymbolsIndex = List.empty(growable: true);
    // list of all players with one or more symbols, as players are used in sets they are removed from this list
    List<Player> playersAvailable = List.empty(growable: true);

    MultiSymbolHelper.constructMultipleSymbolPlayerList(
      team.players,
      playersWithMultipleSymbols,
      playersWithSingleSymbol,
      playerMultipleSymbolsIndex,
      playerMultipleSymbols,
      playersAvailable,
    );

    bool setFound = false;
    // first find sets from players with only one symbol
    for (var playerSk in playersWithSingleSymbol) {
      setFound = false;
      if (playersAvailable.contains(playerSk) &&
          allPlayerStats[playerSk.index].trySymbol == Symbol.skill) {
        for (var playerSa in playersWithSingleSymbol) {
          if (playersAvailable.contains(playerSa) &&
              allPlayerStats[playerSa.index].trySymbol == Symbol.savvy) {
            for (var playerSp in playersWithSingleSymbol) {
              if (playersAvailable.contains(playerSp) &&
                  allPlayerStats[playerSp.index].trySymbol == Symbol.speed) {
                for (var playerSt in playersAvailable) {
                  if (playersAvailable.contains(playerSt) &&
                      allPlayerStats[playerSt.index].trySymbol ==
                          Symbol.strength) {
                    // found a set; remove players from available list
                    playersAvailable.remove(playerSk);
                    playersAvailable.remove(playerSa);
                    playersAvailable.remove(playerSp);
                    playersAvailable.remove(playerSt);
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

    // if there are players with multiple symbols, try different symbol combinations to find more sets
    if (playersWithMultipleSymbols.isNotEmpty) {
      int i = 0;
      recurseFindSets(
        i,
        team,
        playersWithMultipleSymbols,
        playerMultipleSymbolsIndex,
        playersWithSingleSymbol,
        playersAvailable,
        playerMultipleSymbols,
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

  // recursively try all symbol combinations for players with multiple symbols to find the best set count
  void recurseFindSets(
    int i,
    Team team,
    List<Player> playersWithMultipleSymbols,
    List<int> playerMultipleSymbolsIndex,
    List<Player> playersWithSingleSymbol,
    List<Player> playersAvailable,
    List<List<Symbol>> playerMultipleSymbols,
  ) {
    String fn = 'recurseFindSets:';
    debugPrint(
      '$fn multiple symbols player index = $i, symbol index = ${playerMultipleSymbolsIndex[i]}, ${playersWithMultipleSymbols[i]} trySymbol = ${playerMultipleSymbols[i][playerMultipleSymbolsIndex[i]]}',
    );
    // for this player with multiple symbols, set try symbol to the symbol at the current index
    allPlayerStats[playersWithMultipleSymbols[i].index].trySymbol =
        playerMultipleSymbols[i][playerMultipleSymbolsIndex[i]];

    // if more players with multiple symbols
    if (i < playersWithMultipleSymbols.length - 1) {
      recurseFindSets(
        i + 1, // set player index to next player with multiple symbols
        team,
        playersWithMultipleSymbols,
        playerMultipleSymbolsIndex,
        playersWithSingleSymbol,
        playersAvailable,
        playerMultipleSymbols,
      );
    } else {
      // all players with multiple symbols have been assigned a try symbol, see if there are sets
      int setCount = findSets(team, playersAvailable);
      if (setCount > bestSetCount) {
        bestSetCount = setCount;
        debugPrint('....... best set count = $bestSetCount .......');
      }
    }

    // if this player has more symbols to try
    if (playerMultipleSymbolsIndex[i] < (playerMultipleSymbols[i].length - 1)) {
      // increment symbol index to try next symbol for this player and recurse
      playerMultipleSymbolsIndex[i]++;
      recurseFindSets(
        i,
        team,
        playersWithMultipleSymbols,
        playerMultipleSymbolsIndex,
        playersWithSingleSymbol,
        playersAvailable,
        playerMultipleSymbols,
      );
    } else {
      // reset symbol index so next iteration will start at first of multiple symbols
      playerMultipleSymbolsIndex[i] = 0;
    }
  }

  int findSets(Team team, List<Player> playersAvailable) {
    // we don't want to remove players used in sets from playersAvailable
    // so we will keep track of the players we use in sets in this list
    // and check against it as we look for other sets
    List<Player> playersInSets = List.empty(growable: true);
    int foundSets = 0;
    bool setFound = false;

    for (var playerSk in playersAvailable) {
      setFound = false;
      if (playersAvailable.contains(playerSk) &&
          !playersInSets.contains(playerSk) &&
          allPlayerStats[playerSk.index].trySymbol == Symbol.skill) {
        for (var playerSa in playersAvailable) {
          if (playersAvailable.contains(playerSa) &&
              !playersInSets.contains(playerSa) &&
              allPlayerStats[playerSa.index].trySymbol == Symbol.savvy) {
            for (var playerSp in playersAvailable) {
              if (playersAvailable.contains(playerSp) &&
                  !playersInSets.contains(playerSp) &&
                  allPlayerStats[playerSp.index].trySymbol == Symbol.speed) {
                for (var playerSt in playersAvailable) {
                  if (playersAvailable.contains(playerSt) &&
                      !playersInSets.contains(playerSt) &&
                      allPlayerStats[playerSt.index].trySymbol ==
                          Symbol.strength) {
                    playersInSets.add(playerSk);
                    playersInSets.add(playerSa);
                    playersInSets.add(playerSp);
                    playersInSets.add(playerSt);
                    debugPrint(
                      'found set with $playerSk for skill & $playerSa for savvy & $playerSp for speed & $playerSt for strength',
                    );
                    foundSets++;
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

    return foundSets;
  }
}
