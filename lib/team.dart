import 'package:flutter/material.dart';
import 'manager.dart';
import 'player.dart';
import 'tac_card.dart';
import 'position.dart';
import 'score.dart';
import 'cards_in_hand.dart';
import 'high_low_base_points.dart';
import 'color.dart';

List<Team> teams = [];
List<Team> savedTeams = [];

void newTeams() {
  teams = [];
}

class Team {
  Team(this.gamePlayer);

  String gamePlayer = '';
  bool isAutoma = false;
  List<Player> players = List.empty(growable: true);
  Manager? manager;
  Formation? formation;
  Player? keeper;
  int keeperIndex = -1;
  List<TacCard> tacCards = List.empty(growable: true);
  int money = 0;
  List<Player> hand = List.empty(growable: true);
  List<Player> defenders = List.empty(growable: true);
  List<Player> midfielders = List.empty(growable: true);
  List<Player> forwards = List.empty(growable: true);
  List<Player> automaPlayers = List.empty(growable: true);
  List<Player> playersMultipleSymbols = List.empty(growable: true);
  List<Player> playersAdditionalSymbols = List.empty(growable: true);
  Score score = Score();
  Map<Color, bool> moreColor = {
    Color.yellow: false,
    Color.teal: false,
    Color.orange: false,
    Color.red: false,
    Color.purple: false,
  };

  // add the input tac card to the team
  void addTacCard(TacCard tacCard) {
    debugPrint('You just added tac card $tacCard');
    tacCards.add(tacCard);
  }

  // add the input player to the team at the input position
  void addPlayer(Player player, Position position) {
    // if player is already playing, throw exception
    if (allPlayerStats[player.allPlayersIndex].playingPosition != null) {
      throw Exception(
        'Player not available to add, has position ${allPlayerStats[player.allPlayersIndex].playingPosition} ',
      );
    }
    debugPrint('Adding $player to your Best XI as $position');

    // if player is not being added to the bench, add to players
    if (position != Position.bench) {
      players.add(player);
    }

    // add player to the appropriate position list and set the player's playing position
    switch (position) {
      case Position.keeper:
        keeper = player;
        break;
      case Position.defender:
        defenders.add(player);
        debugPrint('Adding $player to your Best XI defenders - defenders count = ${defenders.length}');
        break;
      case Position.midfielder:
        midfielders.add(player);
        debugPrint('Adding $player to your Best XI midfielders - midfielders count = ${midfielders.length}');
        break;
      case Position.forward:
        forwards.add(player);
        debugPrint('Adding $player to your Best XI forwards - forwards count = ${forwards.length}');
        break;
      case Position.player:
        automaPlayers.add(player);
        break;
      case Position.bench:
        hand.add(player);
        break;
    }
    allPlayerStats[player.allPlayersIndex].setPlayingPosition(position);
  }

  List<Player> getPlayersAtPosition(Position position) {
    switch (position) {
      case Position.keeper:
        return keeper != null ? [keeper!] : [];
      case Position.defender:
        return defenders;
      case Position.midfielder:
        return midfielders;
      case Position.forward:
        return forwards;
      case Position.player:
        return automaPlayers;
      case Position.bench:
        return hand;
    }
  }

  void clearPlayersAtPosition(Position position) {
    switch (position) {
      case Position.keeper:
        keeper = null;
        break;
      case Position.defender:
        defenders.clear();
        break;
      case Position.midfielder:
        midfielders.clear();
        break;
      case Position.forward:
        forwards.clear();
        break;
      case Position.player:
        automaPlayers.clear();
        break;
      case Position.bench:
        hand.clear();
        break;
    }
  }

  bool canAddPlayerAtPosition(int numberAtPosition, Position position) {
    // debugPrint('number of defenders: ${defenders.length}');
    // debugPrint('number of midfielders: ${midfielders.length}');
    // debugPrint('number of forwards: ${forwards.length}');
    switch (position) {
      case Position.keeper:
        return numberAtPosition < 1;
      case Position.defender:
        return numberAtPosition < formation!.numberOfDefenders &&
            (numberAtPosition + midfielders.length + forwards.length) < 10;
      case Position.midfielder:
        return numberAtPosition < formation!.numberOfMidfielders &&
            (defenders.length + numberAtPosition + forwards.length) < 10;
      case Position.forward:
        return numberAtPosition < formation!.numberOfForwards &&
            (defenders.length + midfielders.length + numberAtPosition) < 10;
      case Position.player:
        return numberAtPosition < 10;
      case Position.bench:
        return numberAtPosition < 10;
    }
  }

  // return true if any tac card bonus stipulation requires players in hand to calculate the bonus
  bool needPlayersInHand() {
    bool retVal = false;
    for (var card in tacCards) {
      if (card.bonusStipulation.runtimeType == CardsInHand ||
          card.bonusStipulation.runtimeType == HighLowBasePoints) {
        retVal = true;
        break;
      }
    }

    return retVal;
  }

  String toValuesString() {
    return '\'$gamePlayer\', ${manager?.index}, ${keeper?.index}, $money, ${score.tacCards}, ${score.money}, ${score.speed}, ${score.savvy}, ${score.strength}, ${score.skill}, ${score.base}, ${score.total}, ${(score.isHighScore) ? 'TRUE' : 'FALSE'})';
  }
}
