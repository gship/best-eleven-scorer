import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/start_page.dart';
import 'pages/name_entry_page.dart';
import 'pages/money_entry_page.dart';
import 'pages/tac_card_page.dart';
import 'pages/manager_select_page.dart';
import 'pages/manager_solo_select_page.dart';
import 'pages/manager_tile_select_page.dart';
import 'pages/manager_formation_select_page.dart';
import 'pages/keeper_select_page.dart';
import 'pages/score_page.dart';
import 'pages/players_select_page.dart';
import 'pages/players_in_hand_page.dart';
import 'pages/high_scores_page.dart';
import 'pages/saved_game_page.dart';
import 'pages/saved_games_page.dart';
import 'pages/teams_review_page.dart';
import 'pages/best_eleven_match_page.dart';
import 'pages/automa_team_select_page.dart';
import 'position.dart';
import 'player.dart';

const homePage = "/";
const startPage = "startPage";
const nameEntryPage = "nameEntryPage";
const moneyEntryPage = "moneyEntryPage";
const tacCardPage = "tacCardPage";
const managerSelectPage = "managerSelectPage";
const managerSoloSelectPage = "managerSoloSelectPage";
const managerTileSelectPage = "managerTileSelectPage";
const managerFormationSelectPage = "managerFormationSelectPage";
const keeperSelectPage = "keeperSelectPage";
const defendersSelectPage = "defendersSelectPage";
const midfieldersSelectPage = "midfieldersSelectPage";
const forwardsSelectPage = "forwardsSelectPage";
const playersSelectPage = "playersSelectPage";
const automaTeamSelectPage = "automaTeamSelectPage";
const scorePage = "scorePage";
const playersInHandPage = "playersInHandPage";
const highScoresPage = "highScoresPage";
const savedGamePage = "savedGamePage";
const savedGamesPage = "savedGamesPage";
const reviewPage = "reviewPage";
const aboutPage = "aboutPage";
const bestElevenMatchPage = "bestElevenMatchPage";
const bestElevenKeeperMatchPage = "bestElevenKeeperMatchPage";

Map<String, Widget Function(BuildContext)> routes = {
  homePage: (context) => const HomePage(),
  startPage: (context) => const StartPage(),
  nameEntryPage: (context) => const NameEntryPage(),
  moneyEntryPage: (context) => const MoneyEntryPage(),
  tacCardPage: (context) => const TacCardPage(),
  managerSelectPage: (context) => const ManagerSelectPage(),
  managerSoloSelectPage: (context) => const ManagerSoloSelectPage(),
  managerTileSelectPage: (context) => const ManagerTileSelectPage(),
  managerFormationSelectPage: (context) => const ManagerFormationSelectPage(),
  keeperSelectPage: (context) => const KeeperSelectPage(),
  defendersSelectPage: (context) => const PlayersSelectPage(position: Position.defender),
  midfieldersSelectPage: (context) => const PlayersSelectPage(position: Position.midfielder),
  forwardsSelectPage: (context) => const PlayersSelectPage(position: Position.forward),
  automaTeamSelectPage: (context) => const AutomaTeamSelectPage(),
  scorePage: (context) => const ScorePage(),
  playersInHandPage: (context) => const PlayersInHandPage(),
  highScoresPage: (context) => const HighScoresPage(),
  savedGamePage: (context) => const SavedGamePage(),
  savedGamesPage: (context) => const SavedGamesPage(),
  reviewPage: (context) => const TeamsReviewPage(),
  bestElevenMatchPage: (context) => const BestElevenMatchPage(allMatchPlayers: allPlayers, imagePaths: playerImagePaths, radius: 14.0),
  bestElevenKeeperMatchPage: (context) => const BestElevenMatchPage(allMatchPlayers: allKeepers, imagePaths: keeperImagePaths, radius: 10.0),
};
