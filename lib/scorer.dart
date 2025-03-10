import 'package:best_xi_scorer/base_points_equal_one.dart';
import 'package:best_xi_scorer/cards_in_hand.dart';
import 'package:best_xi_scorer/color_of_keeper.dart';
import 'package:best_xi_scorer/multiple_positions.dart';
import 'package:best_xi_scorer/for_each_symbol.dart';
import 'package:best_xi_scorer/no_symbols.dart';
import 'package:best_xi_scorer/player_base_points.dart';
import 'package:best_xi_scorer/high_low_base_points.dart';
import 'package:best_xi_scorer/sets_of_colors_across_lines.dart';
import 'package:best_xi_scorer/sets_of_symbols_across_lines.dart';
import 'package:best_xi_scorer/the_in_the_name.dart';
import 'package:best_xi_scorer/symbol.dart';
import 'package:best_xi_scorer/with_signing_bonus.dart';
import 'team.dart';
import 'package:flutter/material.dart';
import 'no_cards_with_symbol.dart';
import 'cards_with_color.dart';
import 'sets_of_symbols.dart';
import 'sets_of_colors.dart';
import 'money.dart';

class Scorer {
  static void score(Team team) {
    calculateColorScore(team);
    team.score.tacCards = team.score.tacCardColorPoints;
    calculateSymbolScore(team);
    team.score.tacCards += team.score.tacCardSymbolPoints;

    team.score.tacCards += scoreOtherTacCards(team);

    debugPrint('MONEY POINTS = ${team.money}');
    team.score.money = team.money;
    team.score.base = playerBasePoints.calculateBonus(team);
    debugPrint('BASE POINTS = ${team.score.base}');
    team.score.total =
        team.score.tacCards +
        team.score.money +
        team.score.speed +
        team.score.savvy +
        team.score.strength +
        team.score.skill +
        team.score.base;
    debugPrint('TOTAL POINTS = ${team.score.total}');
  }

  static void calculateColorScore(Team team) {
    int tacCardColorPoints = 0;

    debugPrint('TAC CARD COLOR BONUS STIPULATION');
    for (var tacCard in team.tacCards) {
      if (tacCard.bonusStipulation.runtimeType == SetsOfColorsAcrossLines ||
          tacCard.bonusStipulation.runtimeType == SetsOfColors ||
          tacCard.bonusStipulation.runtimeType == CardsWithColor ||
          tacCard.bonusStipulation.runtimeType == ColorOfKeeper) {
        tacCardColorPoints += tacCard.bonusStipulation.calculateBonus(team);
      }
    }
    debugPrint('TAC CARD COLOR BONUS STIPULATION POINTS = $tacCardColorPoints');

    team.score.tacCardColorPoints = tacCardColorPoints;
  }

  static void calculateSymbolScore(Team team) {
    int tacCardSymbolPoints = 0;

    debugPrint('TAC CARD SYMBOL BONUS STIPULATION');
    for (var tacCard in team.tacCards) {
      if (tacCard.bonusStipulation.runtimeType == NoSymbols) {
        tacCardSymbolPoints += tacCard.bonusStipulation.calculateBonus(team);
      } else if (tacCard.bonusStipulation.runtimeType ==
          SetsOfSymbolsAcrossLines) {
        tacCardSymbolPoints += tacCard.bonusStipulation.calculateBonus(team);
      } else if (tacCard.bonusStipulation.runtimeType == SetsOfSymbols) {
        tacCardSymbolPoints += tacCard.bonusStipulation.calculateBonus(team);
      } else if (tacCard.bonusStipulation.runtimeType == NoCardsWithSymbol) {
        tacCardSymbolPoints += tacCard.bonusStipulation.calculateBonus(team);
      }
    }
    debugPrint(
      'TAC CARD SYMBOL BONUS STIPULATION POINTS = $tacCardSymbolPoints',
    );
    team.score.tacCardSymbolPoints = tacCardSymbolPoints;

    team.score.skill = scoreSymbolPoints(team, Symbol.skill);
    debugPrint('SKILL POINTS = ${team.score.skill}');
    team.score.savvy = scoreSymbolPoints(team, Symbol.savvy);
    debugPrint('SAVVY POINTS = ${team.score.savvy}');
    team.score.speed = scoreSymbolPoints(team, Symbol.speed);
    debugPrint('SPEED POINTS = ${team.score.speed}');
    team.score.strength = scoreSymbolPoints(team, Symbol.strength);
    debugPrint('STRENGTH POINTS = ${team.score.strength}');
  }

  static int scoreOtherTacCards(Team team) {
    int points = 0;

    debugPrint('TAC CARD OTHER BONUS STIPULATION');
    for (var tacCard in team.tacCards) {
      if (tacCard.bonusStipulation.runtimeType == Money) {
        points += tacCard.bonusStipulation.calculateBonus(team);
      } else if (tacCard.bonusStipulation.runtimeType == TheInTheName) {
        points += tacCard.bonusStipulation.calculateBonus(team);
      } else if (tacCard.bonusStipulation.runtimeType == CardsInHand) {
        points += tacCard.bonusStipulation.calculateBonus(team);
      } else if (tacCard.bonusStipulation.runtimeType == BasePointsEqualOne) {
        points += tacCard.bonusStipulation.calculateBonus(team);
      } else if (tacCard.bonusStipulation.runtimeType == WithSigningBonus) {
        points += tacCard.bonusStipulation.calculateBonus(team);
      } else if (tacCard.bonusStipulation.runtimeType == MultiplePositions) {
        points += tacCard.bonusStipulation.calculateBonus(team);
      } else if (tacCard.bonusStipulation.runtimeType == HighLowBasePoints) {
        points += tacCard.bonusStipulation.calculateBonus(team);
      }
    }
    debugPrint('TAC CARD OTHER BONUS STIPULATION POINTS = $points');
    return points;
  }

  static int scoreSymbolPoints(Team team, Symbol symbol) {
    int symbols = 0;
    int returnPoints = 0;

    ForEachSymbol forEachSymbol = ForEachSymbol(symbol);
    symbols = forEachSymbol.calculateBonus(team);

    if (team.manager!.addOneToSymbolCounts) {
      debugPrint(
        'adding one to $symbol count for manager ${team.manager!.name}',
      );
      symbols++;
    }

    if (symbols > 6) {
      returnPoints = 18;
    } else if (symbols > 5) {
      returnPoints = 13;
    } else if (symbols > 4) {
      returnPoints = 9;
    } else if (symbols > 3) {
      returnPoints = 6;
    } else if (symbols > 2) {
      returnPoints = 4;
    } else if (symbols > 1) {
      returnPoints = 2;
    } else if (symbols > 0) {
      returnPoints = 1;
    } else {
      returnPoints = 0;
    }

    debugPrint('scoreSymbolPoints - points = $returnPoints');
    return returnPoints;
  }
}
