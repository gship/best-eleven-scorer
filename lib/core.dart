import 'package:best_xi_scorer/best_xi_db.dart';

import 'player.dart';
import 'tac_card.dart';
import 'position.dart';
import 'manager.dart';
import 'high_scores.dart';
import 'save_game.dart';

initialize() async {
  await bestXiDatabase.initialize();
  setTacCardIndices();
  setManagerIndices();
  setKeeperIndices();
  setPlayerIndices();
  setPlayerPositionIndices();
}

void initializeDb() async {
  await highScores.initialize();
  await saveGame.initialize();
}

List<Player> getPositionPlayersFrom(Position position, List<Player> from) {
  List<Player> players = List.empty(growable: true);
  for (var player in from) {
    if (player.isPosition(position)) {
      players.add(player);
    }
  }
  return players;
}

final List<Player> allDefenders = getPositionPlayersFrom(
  Position.defender,
  allPlayers,
);
final List<Player> allMidfielders = getPositionPlayersFrom(
  Position.midfielder,
  allPlayers,
);
final List<Player> allForwards = getPositionPlayersFrom(
  Position.forward,
  allPlayers,
);

void setPlayerPositionIndices() {
  for (int i = 0; i < allDefenders.length; ++i) {
    allDefenders[i].defendersIndex = i;
  }

  for (int i = 0; i < allMidfielders.length; ++i) {
    allMidfielders[i].midfieldersIndex = i;
  }

  for (int i = 0; i < allForwards.length; ++i) {
    allForwards[i].forwardsIndex = i;
  }
}

Core core = Core();
Core savedCore = Core();

void newCore() {
  core = Core();
}

class Core {
  late List<TacCard> selectedTacCards = [];
  late List<Manager> selectedManagers = [];
  late List<Player> selectedKeepers = [];
  late List<Player> selectedDefenders = [];
  late List<Player> selectedMidfielders = [];
  late List<Player> selectedForwards = [];
  late List<Player> playersInHand = [];
  late List<String> gamePlayers = [];
  late int currentPlayer = 0;
  late int numPlayers = 0;

  void reset() {
    selectedTacCards.clear();
    selectedManagers.clear();
    selectedKeepers.clear();
    selectedDefenders.clear();
    selectedMidfielders.clear();
    selectedForwards.clear();
    playersInHand.clear();
    gamePlayers.clear();
    currentPlayer = 0;
    numPlayers = 0;
  }
}
