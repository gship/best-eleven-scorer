import 'package:flutter/material.dart';
import 'package:best_xi_scorer/player.dart';
import 'package:best_xi_scorer/saved_games_db.dart';
import 'core.dart';
import 'tac_card.dart';
import 'team.dart';
import 'saved_game.dart';
import 'package:intl/intl.dart';
import 'manager.dart';

SaveGame saveGame = SaveGame();

class SaveGame {
  late int id;

  initialize() async {
    savedGamesDatabase = SavedGamesDatabase();
    List<SavedGame> savedGames = await savedGamesDatabase.getSavedGames();
    List<int> savedGameIds = [];
    for (var savedGame in savedGames) {
      savedGameIds.add(savedGame.savedGameId);
    }
    // Sort list
    savedGameIds.sort();

    id = savedGameIds.isEmpty ? 1 : ++savedGameIds.last;
    debugPrint('id = $id');
  }

  saveGame() async {
    id++;
    debugPrint('saveGame - id = $id, numPlayers = ${core.numPlayers}');
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    List<String> players = ['', '', '', ''];
    List<int> scores = [0, 0, 0, 0];
    for (int i = 0; i < core.numPlayers; ++i) {
      players[i] = teams[i].gamePlayer;
      scores[i] = teams[i].score.total;
    }
    savedGamesDatabase.saveGame(
      id,
      core.numPlayers,
      formattedDate,
      players[0],
      scores[0],
      players[1],
      scores[1],
      players[2],
      scores[2],
      players[3],
      scores[3],
    );

    String teamsString = '';
    for (int i = 0; i < core.numPlayers; ++i) {
      teamsString += (i == 0) ? '($id, $i, ' : ', ($id, $i, ';
      teamsString += teams[i].toValuesString();

      String tacCardsString = '';
      for (var tacCard in teams[i].tacCards) {
        tacCardsString +=
            ((tacCard == teams[i].tacCards.first)
                ? '($id, $i, '
                : ', ($id, $i, ');
        tacCardsString += tacCard.toValuesString();
      }
      if (tacCardsString.isNotEmpty) {
        await savedGamesDatabase.bulkInsertTacCards(tacCardsString);
      }

      String defendersString = '';
      for (var defender in teams[i].defenders) {
        defendersString +=
            ((defender == teams[i].defenders.first)
                ? '($id, $i, '
                : ', ($id, $i, ');
        defendersString += defender.toValuesString();
      }
      if (defendersString.isNotEmpty) {
        await savedGamesDatabase.bulkInsertDefenders(defendersString);
      }

      String midfieldersString = '';
      for (var midfielder in teams[i].midfielders) {
        midfieldersString +=
            ((midfielder == teams[i].midfielders.first)
                ? '($id, $i, '
                : ', ($id, $i, ');
        midfieldersString += midfielder.toValuesString();
      }
      if (midfieldersString.isNotEmpty) {
        await savedGamesDatabase.bulkInsertMidfielders(midfieldersString);
      }

      String forwardsString = '';
      for (var forward in teams[i].forwards) {
        forwardsString +=
            ((forward == teams[i].forwards.first)
                ? '($id, $i, '
                : ', ($id, $i, ');
        forwardsString += forward.toValuesString();
      }
      if (forwardsString.isNotEmpty) {
        await savedGamesDatabase.bulkInsertForwards(forwardsString);
      }

      String inHandString = '';
      for (var player in teams[i].hand) {
        inHandString +=
            ((player == teams[i].hand.first) ? '($id, $i, ' : ', ($id, $i, ');
        inHandString += player.toValuesString();
      }
      if (inHandString.isNotEmpty) {
        await savedGamesDatabase.bulkInsertPlayersInHand(inHandString);
      }
    }

    debugPrint('teamsString = $teamsString');
    await savedGamesDatabase.bulkInsertTeams(teamsString);
  }

  deleteSavedGame(int savedGameId) async {
    await savedGamesDatabase.deleteSavedGame(savedGameId);
    if (savedGameId == id) {
      initialize();
    }
  }

  Future<List<SavedGame>> getSavedGames() async {
    return await savedGamesDatabase.getSavedGames();
  }

  Future<SavedGame> getSavedGame(int savedGameId) async {
    SavedGame savedGame = await savedGamesDatabase.getSavedGame(savedGameId);
    debugPrint(
      'xxxxx getSavedGame - savedGame.numPlayers = ${savedGame.numPlayers}',
    );

    for (int i = 0; i < savedGame.numPlayers; ++i) {
      debugPrint('getting team $i');
      SavedTeam savedTeam = await savedGamesDatabase.getSavedTeam(
        savedGameId,
        i,
      );
      Team team = Team(savedTeam.gamePlayer);
      team.gamePlayer = savedTeam.gamePlayer;
      team.manager = allManagers[savedTeam.manager];
      team.keeper = allKeepers[savedTeam.keeper];
      team.money = savedTeam.money;
      team.score.tacCards = savedTeam.tacCards;
      team.score.money = savedTeam.scoreMoney;
      team.score.speed = savedTeam.speed;
      team.score.savvy = savedTeam.savvy;
      team.score.strength = savedTeam.strength;
      team.score.skill = savedTeam.skill;
      team.score.base = savedTeam.base;
      team.score.total = savedTeam.total;
      team.score.isHighScore = savedTeam.isHighScore;

      List<SavedInteger> tacCards = await savedGamesDatabase.getSavedTacCards(
        savedGameId,
        i,
      );
      for (var tacCard in tacCards) {
        team.tacCards.add(allTacCards[tacCard.integer]);
      }
      List<SavedInteger> defenders = await savedGamesDatabase.getSavedDefenders(
        savedGameId,
        i,
      );
      for (var defender in defenders) {
        team.defenders.add(allPlayers[defender.integer]);
      }
      List<SavedInteger> midfielders = await savedGamesDatabase
          .getSavedMidfielders(savedGameId, i);
      for (var midfielder in midfielders) {
        team.midfielders.add(allPlayers[midfielder.integer]);
      }
      List<SavedInteger> forwards = await savedGamesDatabase.getSavedForwards(
        savedGameId,
        i,
      );
      for (var forward in forwards) {
        team.forwards.add(allPlayers[forward.integer]);
      }
      List<SavedInteger> players = await savedGamesDatabase.getPlayersInHand(
        savedGameId,
        i,
      );
      for (var player in players) {
        team.hand.add(allPlayers[player.integer]);
      }

      savedTeams.add(team);
      debugPrint('added team savedTeams.length = ${savedTeams.length}');
    }

    return savedGame;
  }
}
