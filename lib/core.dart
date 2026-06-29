import 'package:flutter/material.dart';
import 'best_xi_db.dart';
import 'player.dart';
import 'tac_card.dart';
import 'manager.dart';
import 'high_scores.dart';
import 'save_game.dart';
import 'team.dart';
import 'position.dart';
import 'package:logger/logger.dart';

var logger = Logger();

AssetImage homePageBackgroundImage = const AssetImage('images/home.webp');
AssetImage backgroundImage = const AssetImage('images/background.webp');

Future<void> initialize() async {
  await bestXiDatabase.initialize();
}

Future<void> initializeDb() async {
  await highScores.initialize();
  await saveGame.initialize();
}

Core core = Core();
Core savedCore = Core();

void newCore() {
  core = Core();
}

class Core {
  late List<TacCard> selectedTacCards = [];
  late List<Manager> selectedManagers = [];
  late List<Formation> selectedFormations = [];
  late List<Player> selectedKeepers = [];
  late List<Player> selectedDefenders = [];
  late List<Player> selectedMidfielders = [];
  late List<Player> selectedForwards = [];
  late List<Player> selectedPlayers = [];
  late List<Player> playersInHand = [];
  late List<String> gamePlayers = [];
  late int currentPlayer = 0;
  late int numPlayers = 0;
  late bool inReview = false;
  late bool inManagerReset = false;
  late bool playingWithManagerTiles = false;
  late bool playingSolo = false;

  void reset() {
    selectedTacCards.clear();
    selectedManagers.clear();
    selectedFormations.clear();
    selectedKeepers.clear();
    selectedDefenders.clear();
    selectedMidfielders.clear();
    selectedForwards.clear();
    selectedPlayers.clear();
    playersInHand.clear();
    gamePlayers.clear();
    currentPlayer = 0;
    numPlayers = 0;
    resetAllPlayerStats();
    newTeams();
  }

  void removePlayerAtPosition(Player player, Position position) {
    switch (position) {
      case Position.keeper:
        selectedKeepers.remove(player);
        break;
      case Position.defender:
        selectedDefenders.remove(player);
        break;
      case Position.midfielder:
        selectedMidfielders.remove(player);
        break;
      case Position.forward:
        selectedForwards.remove(player);
        break;
      case Position.player:
        selectedPlayers.remove(player);
        break;
      case Position.bench:
        playersInHand.remove(player);
    }
  }

  void addPlayerAtPosition(Player player, Position position) {
    switch (position) {
      case Position.keeper:
        selectedKeepers.add(player);
        break;
      case Position.defender:
        selectedDefenders.add(player);
        break;
      case Position.midfielder:
        selectedMidfielders.add(player);
        break;
      case Position.forward:
        selectedForwards.add(player);
        break;
      case Position.player:
        selectedPlayers.add(player);
        break;
      case Position.bench:
        playersInHand.add(player);
        break;
    }
  }
}
