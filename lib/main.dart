import 'package:flutter/material.dart';
import 'routes.dart';
import 'pages/home_page.dart';
import 'pages/start_page.dart';
import 'pages/name_entry_page.dart';
import 'pages/money_page.dart';
import 'pages/tac_card_page.dart';
import 'pages/manager_select_page.dart';
import 'pages/keeper_select_page.dart';
import 'pages/defenders_select_page.dart';
import 'pages/midfielders_select_page.dart';
import 'pages/forwards_select_page.dart';
import 'pages/score_page.dart';
import 'pages/players_in_hand_page.dart';
import 'pages/high_scores_page.dart';
import 'pages/saved_game_page.dart';
import 'pages/saved_games_page.dart';
import 'core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();

  initializeDb();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'FranklinGothicURW'),
      //theme: ThemeData(fontFamily: 'Providence'),
      //theme: ThemeData(fontFamily: GoogleFonts.publicSans().fontFamily),
      //theme: ThemeData(fontFamily: GoogleFonts.fuzzyBubbles().fontFamily),
      initialRoute: Routes.homePage,
      routes: {
        Routes.homePage: (context) => const HomePage(),
        Routes.startPage: (context) => const StartPage(),
        Routes.nameEntryPage: (context) => const NameEntryPage(),
        Routes.moneyEntryPage: (context) => const MoneyEntryPage(),
        Routes.tacCardPage: (context) => const TacCardPage(),
        Routes.managerSelectPage: (context) => const ManagerSelectPage(),
        Routes.keeperSelectPage: (context) => const KeeperSelectPage(),
        Routes.defendersSelectPage: (context) => const DefendersSelectPage(),
        Routes.midfieldersSelectPage:
            (context) => const MidfieldersSelectPage(),
        Routes.forwardsSelectPage: (context) => const ForwardsSelectPage(),
        Routes.scorePage: (context) => const ScorePage(),
        Routes.playersInHandPage: (context) => const PlayersInHandPage(),
        Routes.highScoresPage: (context) => const HighScoresPage(),
        Routes.savedGamePage: (context) => const SavedGamePage(),
        Routes.savedGamesPage: (context) => const SavedGamesPage(),
      },
    );
  }
}
