import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

BestXiDatabase bestXiDatabase = BestXiDatabase();

class BestXiDatabase {
  static Database? _database;

  Future<void> initialize() async {
    if (kIsWeb) {
      // Use web implementation on the web.
      databaseFactory = databaseFactoryFfiWeb;
    } else {
      // Use ffi on Linux and Windows.
      if (Platform.isLinux || Platform.isWindows) {
        databaseFactory = databaseFactoryFfi;
        sqfliteFfiInit();
      }
    }

    _database ??= await initDb();
  }

  Future<Database> getDb() async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'best_xi.db');
    //databaseFactory.deleteDatabase(path);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE high_scores (
        id INTEGER PRIMARY KEY,
        date TEXT,
        player TEXT,
        score INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE saved_games (
        savedGameId INTEGER PRIMARY KEY,
        numPlayers INTEGER,
        date TEXT,
        player1 TEXT,
        player1Score INTEGER,
        player2 TEXT,
        player2Score INTEGER,
        player3 TEXT,
        player3Score INTEGER,
        player4 TEXT,
        player4Score INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE saved_teams (
        savedGameId INTEGER,
        playerNum INTEGER,
        gamePlayer TEXT,
        manager INTEGER,
        keeper INTEGER,
        money INTEGER,
        tacCards INTEGER,
        scoreMoney INTEGER,
        speed INTEGER,
        savvy INTEGER,
        strength INTEGER,
        skill INTEGER,
        base INTEGER,
        total INTEGER,
        isHighScore BOOLEAN
      )
    ''');
    await db.execute('''
      CREATE TABLE saved_tac_cards (
        savedGameId INTEGER,
        playerNum INTEGER,
        tacCard INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE saved_defenders (
        savedGameId INTEGER,
        playerNum INTEGER,
        defender integer
      )
    ''');
    await db.execute('''
      CREATE TABLE saved_midfielders (
        savedGameId INTEGER,
        playerNum INTEGER,
        midfielder integer
      )
    ''');
    await db.execute('''
      CREATE TABLE saved_forwards (
        savedGameId INTEGER,
        playerNum INTEGER,
        forward integer
      )
    ''');
    await db.execute('''
      CREATE TABLE players_in_hand (
        savedGameId INTEGER,
        playerNum INTEGER,
        player integer
      )
    ''');
    await db.execute('''
      CREATE TABLE last_players (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        count INTEGER,
        player1 TEXT,
        player2 TEXT,
        player3 TEXT,
        player4 TEXT
      )
    ''');
  }
}
