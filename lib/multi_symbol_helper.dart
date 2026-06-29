import 'player.dart';
import 'symbol.dart';
import 'package:flutter/material.dart';

class MultiSymbolHelper {
  static void constructMultipleSymbolPlayerList(
    List<Player> players,
    List<Player> playersWithMultipleSymbols,
    List<Player> playersWithSingleSymbol,
    // the index of the symbol from playerMultipleSymbols that is to be tried, list index is the player index from playersWithMultipleSymbols
    List<int> playerMultipleSymbolsIndex,
    // the multiple symbols of a player with multiple symbols, outer list index is player, inner list index is 0 through number of symbols -1
    // the inner list index is kept track of in playerMultipleSymbolsIndex
    List<List<Symbol>> playerMultipleSymbols,
    // this will have all players with one or more symbols
    List<Player> playersAvailable,
  ) {
    int multiSymbolsPlayerCount = 0;

    for (var player in players) {
      if (player.numberOfSymbols > 1) {
        _constructMultipleSymbols(
          multiSymbolsPlayerCount,
          player,
          playerMultipleSymbols,
        );
        playersWithMultipleSymbols.add(player);
        playerMultipleSymbolsIndex.add(0); // first index to try is of course 0
        multiSymbolsPlayerCount++;
        playersAvailable.add(player);
      } else if (player.numberOfSymbols == 1) {
        allPlayerStats[player.index].trySymbol =
            player.symbols[0]; // set try symbol to player's only symbol
        playersWithSingleSymbol.add(player);
        playersAvailable.add(player);
      }
    }
  }

  static void _constructMultipleSymbols(
    int index,
    Player player,
    List<List<Symbol>> playerMultipleSymbols,
  ) {
    String fn = 'constructMultipleSymbols:';
    playerMultipleSymbols.add(<Symbol>[]);
    debugPrint(
      '$fn ${player.name} now has ${playerMultipleSymbols.length} playerMultipleSymbols lists',
    );

    for (var symbol in player.symbols) {
      playerMultipleSymbols[index].add(symbol);
      debugPrint(
        '$fn added $symbol to ${player.name} playerMultipleSymbols list $index',
      );
    }
  }
}
