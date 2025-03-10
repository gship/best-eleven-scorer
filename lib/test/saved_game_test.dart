import 'package:best_xi_scorer/pages/saved_game_page.dart';
import 'package:best_xi_scorer/save_game.dart';
import 'package:best_xi_scorer/saved_games_db.dart';
import 'package:flutter/material.dart';
import '../core.dart';
import '../team.dart';
import '../manager.dart';
import '../player.dart';
import '../tac_card.dart';

void main() async {
  // Initialize the database and insert users
  WidgetsFlutterBinding.ensureInitialized();
  initialize();
  await saveGame.initialize();

  core.numPlayers = 2;

  Team team = Team('Glen');
  teams.add(team);

  teams[0].manager = allManagers[2];
  teams[0].keeper = allKeepers[5];
  teams[0].money = 3;
  teams[0].score.tacCards = 23;
  teams[0].score.money = 3;
  teams[0].score.speed = 0;
  teams[0].score.savvy = 2;
  teams[0].score.strength = 6;
  teams[0].score.skill = 6;
  teams[0].score.base = 25;
  teams[0].score.total = 65;
  teams[0].score.isHighScore = true;
  teams[0].tacCards.add(allTacCards[0]);
  teams[0].tacCards.add(allTacCards[1]);
  teams[0].tacCards.add(allTacCards[2]);
  teams[0].tacCards.add(allTacCards[3]);
  teams[0].tacCards.add(allTacCards[4]);
  teams[0].defenders.add(allPlayers[0]);
  teams[0].defenders.add(allPlayers[4]);
  teams[0].defenders.add(allPlayers[21]);
  teams[0].defenders.add(allPlayers[20]);
  teams[0].midfielders.add(allPlayers[6]);
  teams[0].midfielders.add(allPlayers[10]);
  teams[0].midfielders.add(allPlayers[11]);
  teams[0].forwards.add(allPlayers[19]);
  teams[0].forwards.add(allPlayers[23]);
  teams[0].forwards.add(allPlayers[35]);

  team = Team('Sheila');
  teams.add(team);

  teams[1].manager = allManagers[2];
  teams[1].keeper = allKeepers[5];
  teams[1].money = 3;
  teams[1].score.tacCards = 23;
  teams[1].score.money = 3;
  teams[1].score.speed = 0;
  teams[1].score.savvy = 2;
  teams[1].score.strength = 6;
  teams[1].score.skill = 6;
  teams[1].score.base = 25;
  teams[1].score.total = 65;
  teams[1].score.isHighScore = false;
  teams[1].tacCards.add(allTacCards[0]);
  teams[1].tacCards.add(allTacCards[1]);
  teams[1].tacCards.add(allTacCards[2]);
  teams[1].tacCards.add(allTacCards[3]);
  teams[1].tacCards.add(allTacCards[4]);
  teams[1].defenders.add(allPlayers[0]);
  teams[1].defenders.add(allPlayers[4]);
  teams[1].defenders.add(allPlayers[21]);
  teams[1].defenders.add(allPlayers[20]);
  teams[1].midfielders.add(allPlayers[6]);
  teams[1].midfielders.add(allPlayers[10]);
  teams[1].midfielders.add(allPlayers[11]);
  teams[1].forwards.add(allPlayers[19]);
  teams[1].forwards.add(allPlayers[23]);
  teams[1].forwards.add(allPlayers[35]);

  await savedGamesDatabase.deleteSavedGames();
  debugPrint('deleted saved games');
  await saveGame.saveGame();
  debugPrint('saved game');

  //runApp(MyApp());
  runApp(SavedGamePage());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SavedGame',
      home: SavedGameList(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SavedGameList extends StatefulWidget {
  const SavedGameList({super.key});

  @override
  State<SavedGameList> createState() => _SavedGameListState();
}

class _SavedGameListState extends State<SavedGameList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Game'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: List.generate(savedTeams.length, (index) {
          return Column(
            children: [
              Text(savedTeams[index].toValuesString()),
              Text('player = ${savedTeams[index].gamePlayer}'),
              Text('money = ${savedTeams[index].money}'),
            ],
          );
        }),
      ),
    );
  }
}
