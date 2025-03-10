import 'package:flutter/material.dart';
import 'manager.dart';
import 'player.dart';
import 'tac_card.dart';
import 'position.dart';
import 'score.dart';
import 'cards_in_hand.dart';
import 'high_low_base_points.dart';

List<Team> teams = [];
List<Team> savedTeams = [];

void newTeams() {
  teams = [];
}

class Team {
  Team(this.gamePlayer);

  String gamePlayer = '';
  List<Player> players = List.empty(growable: true);
  Manager? manager;
  Player? keeper;
  List<TacCard> tacCards = List.empty(growable: true);
  int money = 0;
  List<Player> hand = List.empty(growable: true);
  List<Player> defenders = List.empty(growable: true);
  List<Player> midfielders = List.empty(growable: true);
  List<Player> forwards = List.empty(growable: true);
  List<Player> playersMultipleSymbols = List.empty(growable: true);
  List<Player> playersAdditionalSymbols = List.empty(growable: true);
  Score score = Score();
  bool checkedForCardsInHand = false;

  void addTacCard(TacCard tacCard) {
    debugPrint('You just added tac card $tacCard');
    tacCards.add(tacCard);
  }

  void addPlayer(Player player, Position position) {
    if (player.playingPosition != null) {
      throw Exception('Player not available to add');
    }
    debugPrint('Adding $player to your Best XI as $position');

    if (position != Position.bench) {
      players.add(player);
    }
    switch (position) {
      case Position.keeper:
        keeper = player;
        break;
      case Position.defender:
        defenders.add(player);
        break;
      case Position.midfielder:
        midfielders.add(player);
        break;
      case Position.forward:
        forwards.add(player);
        break;
      case Position.bench:
        hand.add(player);
        break;
    }
    player.setPlayingPosition(position);
  }

  bool needPlayersInHand() {
    bool retVal = false;
    if (!checkedForCardsInHand) {
      for (var card in tacCards) {
        if (card.bonusStipulation.runtimeType == CardsInHand ||
            card.bonusStipulation.runtimeType == HighLowBasePoints) {
          retVal = true;
          break;
        }
      }
    }

    checkedForCardsInHand = true;
    return retVal;
  }

  String toValuesString() {
    return '\'$gamePlayer\', ${manager?.index}, ${keeper?.index}, $money, ${score.tacCards}, ${score.money}, ${score.speed}, ${score.savvy}, ${score.strength}, ${score.skill}, ${score.base}, ${score.total}, ${(score.isHighScore) ? 'TRUE' : 'FALSE'})';
  }
}
