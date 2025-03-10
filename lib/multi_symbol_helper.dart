import 'player.dart';
import 'symbol.dart';
import 'package:flutter/material.dart';

class MultiSymbolHelper {
  static void constructMultipleSymbolPlayerList(
    List<Player> players,
    List<Player> playersMultipleSymbols,
    List<Player> playersWithSingleSymbol,
    List<int> playerSelectIndexes,
    // each player with multiple symbols will have an index to iterate over its symbols
    List<List<Symbol>> playerTrySymbols,
    // the multiple symbols to try for a player
    List<Player> playersNotIn,
  ) // this will have all players with one or more symbols
  {
    int multiSymbolsPlayerCount = 0;

    for (var player in players) {
      if (player.numberOfSymbols > 1) {
        _constructMultipleSymbols(
          multiSymbolsPlayerCount,
          player,
          playerTrySymbols,
        );
        playersMultipleSymbols.add(player);
        playerSelectIndexes.add(0); // first index to try is of course 0
        multiSymbolsPlayerCount++;
        playersNotIn.add(player);
      } else if (player.numberOfSymbols == 1) {
        player.trySymbol =
            player.symbols[0]; // set try symbol to player's only symbol
        playersWithSingleSymbol.add(player);
        playersNotIn.add(player);
      } else if (player.chosenSymbol != null) {
        debugPrint(
          'SETTING TRY SYMBOL TO CHOSEN SYMBOL, ${player.chosenSymbol} for ${player.name}',
        );
        player.trySymbol = player.chosenSymbol;
        playersWithSingleSymbol.add(player);
        playersNotIn.add(player);
      }
    }
  }

  static void _constructMultipleSymbols(
    int index,
    Player player,
    List<List<Symbol>> playerTrySymbols,
  ) {
    debugPrint(
      'constructMultipleSymbols - $player, playerTrySymbols.length = ${playerTrySymbols.length}',
    );
    playerTrySymbols.add(<Symbol>[]);
    debugPrint(
      'constructMultipleSymbols - $player, playerTrySymbols.length = ${playerTrySymbols.length}',
    );

    for (var symbol in player.symbols) {
      playerTrySymbols[index].add(symbol);
    }

    // code past here is for debug purposes only
    for (var symbol in playerTrySymbols[index]) {
      debugPrint('has $symbol');
    }

    debugPrint('$player trySymbols = ');
    for (var symbol in playerTrySymbols[index]) {
      debugPrint('$symbol');
    }
  }
}
