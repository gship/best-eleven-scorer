import 'base_points_equal_one.dart';
import 'cards_in_hand.dart';
import 'color_of_keeper.dart';
import 'multiple_positions.dart';
import 'for_each_symbol.dart';
import 'no_symbols.dart';
import 'player_base_points.dart';
import 'high_low_base_points.dart';
import 'sets_of_colors_across_lines.dart';
import 'sets_of_symbols_across_lines.dart';
import 'the_in_the_name.dart';
import 'symbol.dart';
import 'with_signing_bonus.dart';
import 'team.dart';
import 'package:flutter/material.dart';
import 'no_cards_with_symbol.dart';
import 'cards_with_color.dart';
import 'sets_of_symbols.dart';
import 'sets_of_colors.dart';
import 'money.dart';
import 'player.dart';

final int maxStats = 4;
int bestSymbolPoints = 0;
List<int> bestStatLevel = [];
int bestTacCardSymbolPoints = 0;
int bestSpeed = 0;
int bestSavvy = 0;
int bestStrength = 0;
int bestSkill = 0;

class Scorer {
  static void score(Team team) {
    calculateColorScore(team);
    team.score.tacCards = team.score.tacCardColorPoints;

    List<int> indexWithWildStat = [];
    List<int> indexWithNoSymbols = [];
    bool hasWildStats = false;
    bool hasNoSymbols = false;
    for (int i = 0; i < team.players.length; i++) {
      allPlayerStats[team.players[i].allPlayersIndex].numberOfSkills =
          team.players[i].numberOfSkills;
      allPlayerStats[team.players[i].allPlayersIndex].numberOfSavvies =
          team.players[i].numberOfSavvies;
      allPlayerStats[team.players[i].allPlayersIndex].numberOfSpeeds =
          team.players[i].numberOfSpeeds;
      allPlayerStats[team.players[i].allPlayersIndex].numberOfStrengths =
          team.players[i].numberOfStrengths;
      debugPrint('Player ${team.players[i].name}');
      if (team.players[i].hasWildStat) {
        debugPrint(
          'has wild stat----------------------------------------------',
        );
        indexWithWildStat.add(i);
        hasWildStats = true;
      } else if (team.players[i].numberOfSymbols == 0) {
        debugPrint(
          'has no stats----------------------------------------------',
        );
        indexWithNoSymbols.add(i);
        hasNoSymbols = true;
      }
    }

    bestSymbolPoints = 0;
    bestTacCardSymbolPoints = 0;
    bestSpeed = 0;
    bestSavvy = 0;
    bestStrength = 0;
    bestSkill = 0;
    bestStatLevel = List.filled(indexWithWildStat.length, 0);

    if (team.manager?.name == 'Teodoro Reata' && hasNoSymbols) {
      int bestTeodoroSymbol = 0;
      // try all stat symbols for each player with no symbols
      for (int i = 0; i < maxStats + 1; i++) {
        debugPrint(
          "trying symbol = ${getStatText(i)} for Teodoro Reata ----------------------------------------------",
        );
        for (int j = 0; j < indexWithNoSymbols.length; j++) {
          debugPrint(
            'assigning symbol ${getStatText(i)} to player ${team.players[indexWithNoSymbols[j]].name}',
          );
          setStatCounts(team, indexWithNoSymbols[j], i);
        }
        // calculate the symbol score for this assignment of stats to players with no symbols
        if (hasWildStats) {
          bool isNewBest = calculateWildstatsSymbolScore(
            team,
            indexWithWildStat,
          );
          if (isNewBest) {
            debugPrint(
              'new best symbol points = $bestSymbolPoints for Teodoro Reata stat ${getStatText(i)} ------------------------------------',
            );
            bestTeodoroSymbol = i;
          }
        } else {
          calculateSymbolScore(team);
          int symbolPoints =
              team.score.tacCardSymbolPoints +
              team.score.speed +
              team.score.savvy +
              team.score.strength +
              team.score.skill;

          if (symbolPoints > bestSymbolPoints) {
            // save this as the best assignment of wild stat values
            debugPrint(
              'new best symbol points = $symbolPoints ------------------------------------',
            );
            debugPrint(
              '--------------------- Teodoro symbol = ${getStatText(i)} -------------',
            );
            bestSymbolPoints = symbolPoints;
            bestTacCardSymbolPoints = team.score.tacCardSymbolPoints;
            bestSpeed = team.score.speed;
            bestSavvy = team.score.savvy;
            bestStrength = team.score.strength;
            bestSkill = team.score.skill;
            bestTeodoroSymbol = i;
          }
        }
      }
      // assign the best stat values to the team
      team.score.tacCardSymbolPoints = bestTacCardSymbolPoints;
      team.score.speed = bestSpeed;
      team.score.savvy = bestSavvy;
      team.score.strength = bestStrength;
      team.score.skill = bestSkill;
      debugPrint(
        '--------------------- best Teodoro symbol = ${getStatText(bestTeodoroSymbol)} -------------',
      );
    } else if (hasWildStats) {
      calculateWildstatsSymbolScore(team, indexWithWildStat);
    } else {
      calculateSymbolScore(team);
    }

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

  static bool calculateWildstatsSymbolScore(
    Team team,
    List<int> indexWithWildStat,
  ) {
    // Iterate recursively through all indexWithWildStat assigning them one of the four stats
    List<int> statLevel = List.filled(indexWithWildStat.length, 0);

    bool isNewBest = recursiveWildStatAssignment(
      team,
      indexWithWildStat,
      0,
      statLevel,
    );

    // loop through bestStatLevel and print out the best stat for each player with wild stat
    for (int i = 0; i < indexWithWildStat.length; i++) {
      debugPrint(
        '-------------------- best stat level ------------------------------------------------------------------------------',
      );
      debugPrint(
        '${getStatText(bestStatLevel[i])} for player ${team.players[indexWithWildStat[i]].name}',
      );
    }
    // assign the best stat values to the team
    team.score.tacCardSymbolPoints = bestTacCardSymbolPoints;
    team.score.speed = bestSpeed;
    team.score.savvy = bestSavvy;
    team.score.strength = bestStrength;
    team.score.skill = bestSkill;

    return isNewBest;
  }

  static bool recursiveWildStatAssignment(
    Team team,
    List<int> indexWithWildStat,
    int level,
    List<int> statLevel,
  ) {
    bool isNewBest = false;
    setStatCounts(team, indexWithWildStat[level], statLevel[level]);

    if (level < indexWithWildStat.length - 1) {
      recursiveWildStatAssignment(
        team,
        indexWithWildStat,
        level + 1,
        statLevel,
      );
    } else {
      calculateSymbolScore(team);
      int symbolPoints =
          team.score.tacCardSymbolPoints +
          team.score.speed +
          team.score.savvy +
          team.score.strength +
          team.score.skill;

      if (symbolPoints > bestSymbolPoints) {
        isNewBest = true;
        // save this as the best assignment of wild stat values
        debugPrint(
          'new best symbol points = $symbolPoints ------------------------------------',
        );
        bestSymbolPoints = symbolPoints;
        bestTacCardSymbolPoints = team.score.tacCardSymbolPoints;
        bestSpeed = team.score.speed;
        bestSavvy = team.score.savvy;
        bestStrength = team.score.strength;
        bestSkill = team.score.skill;
        for (int i = 0; i < indexWithWildStat.length; i++) {
          bestStatLevel[i] = statLevel[i];
          debugPrint(
            '${getStatText(bestStatLevel[i])} for player ${team.players[indexWithWildStat[i]].name}',
          );
        }
      }
    }

    if (statLevel[level] < maxStats) {
      statLevel[level]++;
      recursiveWildStatAssignment(team, indexWithWildStat, level, statLevel);
    } else {
      statLevel[level] = 0;
    }

    return isNewBest;
  }

  static void setStatCounts(Team team, int index, int stat) {
    switch (stat) {
      case 0:
        allPlayerStats[team.players[index].allPlayersIndex].numberOfSkills = 0;
        allPlayerStats[team.players[index].allPlayersIndex].numberOfSavvies = 0;
        allPlayerStats[team.players[index].allPlayersIndex].numberOfSpeeds = 0;
        allPlayerStats[team.players[index].allPlayersIndex].numberOfStrengths =
            0;
        break;
      case 1:
        allPlayerStats[team.players[index].allPlayersIndex].numberOfSkills = 1;
        allPlayerStats[team.players[index].allPlayersIndex].numberOfSavvies = 0;
        allPlayerStats[team.players[index].allPlayersIndex].numberOfSpeeds = 0;
        allPlayerStats[team.players[index].allPlayersIndex].numberOfStrengths =
            0;
        break;
      case 2:
        allPlayerStats[team.players[index].allPlayersIndex].numberOfSkills = 0;
        allPlayerStats[team.players[index].allPlayersIndex].numberOfSavvies = 1;
        allPlayerStats[team.players[index].allPlayersIndex].numberOfSpeeds = 0;
        allPlayerStats[team.players[index].allPlayersIndex].numberOfStrengths =
            0;
        break;
      case 3:
        allPlayerStats[team.players[index].allPlayersIndex].numberOfSkills = 0;
        allPlayerStats[team.players[index].allPlayersIndex].numberOfSavvies = 0;
        allPlayerStats[team.players[index].allPlayersIndex].numberOfSpeeds = 1;
        allPlayerStats[team.players[index].allPlayersIndex].numberOfStrengths =
            0;
        break;
      case 4:
        allPlayerStats[team.players[index].allPlayersIndex].numberOfSkills = 0;
        allPlayerStats[team.players[index].allPlayersIndex].numberOfSavvies = 0;
        allPlayerStats[team.players[index].allPlayersIndex].numberOfSpeeds = 0;
        allPlayerStats[team.players[index].allPlayersIndex].numberOfStrengths =
            1;
        break;
    }
  }

  static String getStatText(int stat) {
    switch (stat) {
      case 0:
        return 'None';
      case 1:
        return 'Skill';
      case 2:
        return 'Intelligence';
      case 3:
        return 'Speed';
      case 4:
        return 'Strength';
    }

    return '';
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

  static int symbolPoints(int numberOfSymbol) {
    int returnPoints = 0;

    if (numberOfSymbol > 6) {
      returnPoints = 18;
    } else if (numberOfSymbol > 5) {
      returnPoints = 13;
    } else if (numberOfSymbol > 4) {
      returnPoints = 9;
    } else if (numberOfSymbol > 3) {
      returnPoints = 6;
    } else if (numberOfSymbol > 2) {
      returnPoints = 4;
    } else if (numberOfSymbol > 1) {
      returnPoints = 2;
    } else if (numberOfSymbol > 0) {
      returnPoints = 1;
    } else {
      returnPoints = 0;
    }

    debugPrint('symbolPoints is $returnPoints');
    return returnPoints;
  }

  static int scoreSymbolPoints(Team team, Symbol symbol) {
    int numberOfSymbol = 0;

    ForEachSymbol forEachSymbol = ForEachSymbol(symbol);
    numberOfSymbol = forEachSymbol.calculateBonus(team);

    if (team.manager!.addOneToSymbolCounts) {
      debugPrint(
        'adding one to $symbol count for manager ${team.manager!.name}',
      );
      numberOfSymbol++;
    }

    return symbolPoints(numberOfSymbol);
  }

  static void scoreAutoma(Team team) {
    int signingBonusCount = 0;
    List<int> symbolCounts = [0, 0, 0, 0];

    team.score.money = team.money;
    team.score.base = playerBasePoints.calculateBonus(team);

    // loop through players, count signing bonuses and symbols
    for (var player in team.players) {
      if (player.hasSigningBonus) {
        signingBonusCount++;
      }
      if (player.hasWildStat) {
        signingBonusCount++;
      }
      symbolCounts[0] += player.numberOfSkills;
      symbolCounts[1] += player.numberOfSavvies;
      symbolCounts[2] += player.numberOfSpeeds;
      symbolCounts[3] += player.numberOfStrengths;
    }

    var sortedSymbolCounts = List<int>.from(symbolCounts)..sort();

    if (sortedSymbolCounts[3] + signingBonusCount > 7) {
      signingBonusCount = 7 - sortedSymbolCounts[3] - 1;
      sortedSymbolCounts[3] = 7;
      if (sortedSymbolCounts[2] + signingBonusCount > 7) {
        signingBonusCount = 7 - sortedSymbolCounts[2] - 1;
        sortedSymbolCounts[2] = 7;
        if (sortedSymbolCounts[1] + signingBonusCount > 7) {
          signingBonusCount = 7 - sortedSymbolCounts[1] - 1;
          sortedSymbolCounts[1] = 7;
          if (sortedSymbolCounts[0] + signingBonusCount > 7) {
            signingBonusCount = 7 - sortedSymbolCounts[0];
          } else {
            sortedSymbolCounts[0] += signingBonusCount;
          }
        } else {
          sortedSymbolCounts[1] += signingBonusCount;
        }
      } else {
        sortedSymbolCounts[2] += signingBonusCount;
      }
    } else {
      sortedSymbolCounts[3] += signingBonusCount;
    }

    team.score.skill = symbolPoints(sortedSymbolCounts[0]);
    team.score.savvy = symbolPoints(sortedSymbolCounts[1]);
    team.score.speed = symbolPoints(sortedSymbolCounts[2]);
    team.score.strength = symbolPoints(sortedSymbolCounts[3]);
    team.score.total =
        team.score.money +
        team.score.base +
        team.score.skill +
        team.score.savvy +
        team.score.speed +
        team.score.strength;
  }
}
