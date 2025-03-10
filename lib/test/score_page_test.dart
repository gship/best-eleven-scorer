import 'package:best_xi_scorer/pages/score_page.dart';
import 'package:best_xi_scorer/player.dart';
import 'package:best_xi_scorer/tac_card.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import '../core.dart';
import '../team.dart';
import '../manager.dart';
import '../position.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../best_xi_db.dart';
import '../high_scores_db.dart';

Team team = Team('Brigham');
List<String> names = ['Matt', 'Elise', 'Grandmaster Funk', 'Olivia'];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // Use web implementation on the web.
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    // Use ffi on Linux and Windows.
    //databaseFactory = databaseFactoryFfi;
    //sqfliteFfiInit();
  }
  await bestXiDatabase.initDb();
  await highScoresDatabase.deleteHighScores();

  initialize();

  teams.add(team);
  teams.add(team);
  teams.add(team);
  teams.add(team);
  core.currentPlayer = 0;
  core.numPlayers = 1;
  team.money = 120;
  team.tacCards.add(allTacCards[18]);
  team.tacCards.add(allTacCards[9]);
  team.manager = allManagers[2];
  team.keeper = allKeepers[5];
  team.addPlayer(allKeepers[5], Position.keeper);
  team.defenders.add(allPlayers[45]);
  team.addPlayer(allPlayers[45], Position.defender);
  team.defenders.add(allPlayers[17]);
  team.addPlayer(allPlayers[17], Position.defender);
  team.defenders.add(allPlayers[46]);
  team.addPlayer(allPlayers[46], Position.defender);
  team.defenders.add(allPlayers[85]);
  team.addPlayer(allPlayers[85], Position.defender);
  team.midfielders.add(allPlayers[48]);
  team.addPlayer(allPlayers[48], Position.midfielder);
  team.midfielders.add(allPlayers[73]);
  team.addPlayer(allPlayers[73], Position.midfielder);
  team.midfielders.add(allPlayers[90]);
  team.addPlayer(allPlayers[90], Position.midfielder);
  team.forwards.add(allPlayers[14]);
  team.addPlayer(allPlayers[14], Position.forward);
  team.forwards.add(allPlayers[79]);
  team.addPlayer(allPlayers[79], Position.forward);
  team.forwards.add(allPlayers[93]);
  team.addPlayer(allPlayers[93], Position.forward);

  runApp(const ScorePage());
}