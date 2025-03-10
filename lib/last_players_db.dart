import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'best_xi_db.dart';

class LastPlayers {
  late int id = 1;
  late int count;
  late String player1 = '';
  late String player2 = '';
  late String player3 = '';
  late String player4 = '';

  LastPlayers();

  LastPlayers.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    count = map['count'];
    player1 = map['player1'];
    player2 = map['player2'];
    player3 = map['player3'];
    player4 = map['player4'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'count': count,
      'player1': player1,
      'player2': player2,
      'player3': player3,
      'player4': player4,
    };
  }
}

LastPlayersDatabase lastPlayersDatabase = LastPlayersDatabase();

class LastPlayersDatabase {
  clearLastPlayers() async {
    Database db = await bestXiDatabase.getDb();
    await db.delete('last_players');
  }

  insertLastPlayers(LastPlayers lastPlayers) async {
    Database db = await bestXiDatabase.getDb();
    int? count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM last_players'));
    debugPrint('insertLastPlayers - count: $count');

    if (count! > 0) {
      await db.update(
          'last_players',
          lastPlayers.toMap(),
          where: 'id = ?',
          whereArgs: [1]);
    }
    else {
      await db.insert(
          'last_players',
          lastPlayers.toMap());
    }
  }

  Future<List<LastPlayers>> getLastPlayers() async {
    Database db = await bestXiDatabase.getDb();
    final List<Map<String, Object?>> lastPlayers = await db.query(
        'last_players');
    debugPrint('getLastPlayers - got ${lastPlayers.length}');
    if (lastPlayers.isEmpty) {
      return [];
    }
    return [
      for (final lastPlayer in lastPlayers) LastPlayers.fromMap(lastPlayer)];
  }
}
