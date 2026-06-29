import 'package:sqflite/sqflite.dart';
import 'saved_game.dart';
import 'best_xi_db.dart';

SavedGamesDatabase savedGamesDatabase = SavedGamesDatabase();

class SavedGamesDatabase {
  Future<void> saveGame(
    int id,
    int numPlayers,
    String formattedDate,
    String player1,
    int player1Score,
    String player2,
    int player2Score,
    String player3,
    int player3Score,
    String player4,
    int player4Score,
  ) async {
    Database db = await bestXiDatabase.getDb();
    await db.rawInsert(
      'insert into saved_games (savedGameId, numPlayers, date, player1, player1Score, player2, player2Score, player3, player3Score, player4, player4Score) values ('
      '$id, $numPlayers, \'$formattedDate\', \'$player1\', $player1Score, \'$player2\', $player2Score, \'$player3\', $player3Score, \'$player4\', $player4Score)',
    );
  }

  Future<void> bulkInsertTeams(String valuesString) async {
    Database db = await bestXiDatabase.getDb();
    await db.rawInsert(
      'insert into saved_teams (savedGameId, playerNum, gamePlayer, manager, keeper, money, tacCards, scoreMoney, speed, savvy, strength, skill, base, total, isHighScore) values $valuesString',
    );
  }

  Future<void> bulkInsertTacCards(String valuesString) async {
    Database db = await bestXiDatabase.getDb();
    await db.rawInsert(
      'insert into saved_tac_cards (savedGameId, playerNum, tacCard) values $valuesString',
    );
  }

  Future<void> bulkInsertDefenders(String valuesString) async {
    Database db = await bestXiDatabase.getDb();
    await db.rawInsert(
      'insert into saved_defenders (savedGameId, playerNum, defender) values $valuesString',
    );
  }

  Future<void> bulkInsertMidfielders(String valuesString) async {
    Database db = await bestXiDatabase.getDb();
    await db.rawInsert(
      'insert into saved_midfielders (savedGameId, playerNum, midfielder) values $valuesString',
    );
  }

  Future<void> bulkInsertForwards(String valuesString) async {
    Database db = await bestXiDatabase.getDb();
    await db.rawInsert(
      'insert into saved_forwards (savedGameId, playerNum, forward) values $valuesString',
    );
  }

  Future<void> bulkInsertPlayersInHand(String valuesString) async {
    Database db = await bestXiDatabase.getDb();
    await db.rawInsert(
      'insert into players_in_hand (savedGameId, playerNum, player) values $valuesString',
    );
  }

  Future<void> deleteSavedGame(int savedGameId) async {
    Database db = await bestXiDatabase.getDb();
    await db.delete(
      'saved_games',
      where: 'savedGameId = ?',
      whereArgs: [savedGameId],
    );
    await db.delete(
      'saved_teams',
      where: 'savedGameId = ?',
      whereArgs: [savedGameId],
    );
    await db.delete(
      'saved_tac_cards',
      where: 'savedGameId = ?',
      whereArgs: [savedGameId],
    );
    await db.delete(
      'saved_defenders',
      where: 'savedGameId = ?',
      whereArgs: [savedGameId],
    );
    await db.delete(
      'saved_midfielders',
      where: 'savedGameId = ?',
      whereArgs: [savedGameId],
    );
    await db.delete(
      'saved_forwards',
      where: 'savedGameId = ?',
      whereArgs: [savedGameId],
    );
    await db.delete(
      'players_in_hand',
      where: 'savedGameId = ?',
      whereArgs: [savedGameId],
    );
  }

  Future<void> deleteSavedGames() async {
    Database db = await bestXiDatabase.getDb();
    await db.delete('last_saved_games_id');
    await db.delete('saved_games');
    await db.delete('saved_teams');
    await db.delete('saved_tac_cards');
    await db.delete('saved_defenders');
    await db.delete('saved_midfielders');
    await db.delete('saved_forwards');
    await db.delete('players_in_hand');
  }

  Future<List<SavedGame>> getSavedGames() async {
    Database db = await bestXiDatabase.getDb();
    final List<Map<String, Object?>> savedGames = await db.query('saved_games');
    return [
      for (final {
            'savedGameId': savedGameId as int,
            'numPlayers': numPlayers as int,
            'date': date as String,
            'player1': player1 as String,
            'player1Score': player1Score as int,
            'player2': player2 as String,
            'player2Score': player2Score as int,
            'player3': player3 as String,
            'player3Score': player3Score as int,
            'player4': player4 as String,
            'player4Score': player4Score as int,
          }
          in savedGames)
        SavedGame(
          savedGameId: savedGameId,
          numPlayers: numPlayers,
          date: date,
          player1: player1,
          player1Score: player1Score,
          player2: player2,
          player2Score: player2Score,
          player3: player3,
          player3Score: player3Score,
          player4: player4,
          player4Score: player4Score,
        ),
    ];
  }

  Future<SavedGame> getSavedGame(int savedGameId) async {
    Database db = await bestXiDatabase.getDb();
    final savedGames = await db.query(
      'saved_games',
      limit: 1,
      where: 'savedGameId= ?',
      whereArgs: [savedGameId],
    );

    SavedGame savedGame = SavedGame(savedGameId: 0, numPlayers: 0, date: '');

    if (savedGames.isNotEmpty) {
      savedGame = SavedGame(
        savedGameId: savedGames.first['savedGameId'] as int,
        numPlayers: savedGames.first['numPlayers'] as int,
        date: savedGames.first['date'] as String,
      );
    }

    return savedGame;
  }

  Future<SavedTeam> getSavedTeam(int savedGameId, int playerNum) async {
    Database db = await bestXiDatabase.getDb();

    final savedTeams = await db.query(
      'saved_teams',
      where: 'savedGameId = ? and playerNum = ?',
      whereArgs: [savedGameId, playerNum],
    );

    final savedTeam = SavedTeam(
      gamePlayer: savedTeams.first['gamePlayer'] as String,
      manager: savedTeams.first['manager'] as int,
      keeper: savedTeams.first['keeper'] as int,
      money: savedTeams.first['money'] as int,
      tacCards: savedTeams.first['tacCards'] as int,
      scoreMoney: savedTeams.first['scoreMoney'] as int,
      speed: savedTeams.first['speed'] as int,
      savvy: savedTeams.first['savvy'] as int,
      strength: savedTeams.first['strength'] as int,
      skill: savedTeams.first['skill'] as int,
      base: savedTeams.first['base'] as int,
      total: savedTeams.first['total'] as int,
      isHighScore: (savedTeams.first['isHighScore'] as int == 1) ? true : false,
    );

    return savedTeam;
  }

  Future<List<SavedInteger>> getSavedTacCards(
    int savedGameId,
    int playerNum,
  ) async {
    Database db = await bestXiDatabase.getDb();

    final List<Map<String, Object?>> savedTacCards = await db.query(
      'saved_tac_cards',
      where: 'savedGameId = ? and playerNum = ?',
      whereArgs: [savedGameId, playerNum],
    );
    return [
      for (final {'tacCard': tacCard as int} in savedTacCards)
        SavedInteger(integer: tacCard),
    ];
  }

  Future<List<SavedInteger>> getSavedDefenders(
    int savedGameId,
    int playerNum,
  ) async {
    Database db = await bestXiDatabase.getDb();

    final List<Map<String, Object?>> savedDefenders = await db.query(
      'saved_defenders',
      where: 'savedGameId = ? and playerNum = ?',
      whereArgs: [savedGameId, playerNum],
    );
    return [
      for (final {'defender': defender as int} in savedDefenders)
        SavedInteger(integer: defender),
    ];
  }

  Future<List<SavedInteger>> getSavedMidfielders(
    int savedGameId,
    int playerNum,
  ) async {
    Database db = await bestXiDatabase.getDb();

    final List<Map<String, Object?>> savedMidfielders = await db.query(
      'saved_midfielders',
      where: 'savedGameId = ? and playerNum = ?',
      whereArgs: [savedGameId, playerNum],
    );
    return [
      for (final {'midfielder': midfielder as int} in savedMidfielders)
        SavedInteger(integer: midfielder),
    ];
  }

  Future<List<SavedInteger>> getSavedForwards(
    int savedGameId,
    int playerNum,
  ) async {
    Database db = await bestXiDatabase.getDb();

    final List<Map<String, Object?>> savedForwards = await db.query(
      'saved_forwards',
      where: 'savedGameId = ? and playerNum = ?',
      whereArgs: [savedGameId, playerNum],
    );
    return [
      for (final {'forward': forward as int} in savedForwards)
        SavedInteger(integer: forward),
    ];
  }

  Future<List<SavedInteger>> getPlayersInHand(
    int savedGameId,
    int playerNum,
  ) async {
    Database db = await bestXiDatabase.getDb();

    final List<Map<String, Object?>> savedForwards = await db.query(
      'players_in_hand',
      where: 'savedGameId = ? and playerNum = ?',
      whereArgs: [savedGameId, playerNum],
    );
    return [
      for (final {'player': player as int} in savedForwards)
        SavedInteger(integer: player),
    ];
  }
}
