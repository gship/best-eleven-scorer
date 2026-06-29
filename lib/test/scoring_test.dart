import 'dart:io';
import 'package:flutter/material.dart';
import '../team.dart';
import '../player.dart';
import '../tac_card.dart';
import '../manager.dart';
import '../scorer.dart';
import '../position.dart';
import '../score.dart';

void main() async {
  // open file ./data/scoring_test_data.txt and read the lines into a list of strings
  var file = File(
    'C:/Users/gship_000/StudioProjects/best_eleven_scorerorer/lib/test/data/scoring_test_data.txt',
  );
  try {
    var scoringTestData = await file.readAsString();
    List<String> lines = scoringTestData.split('\n');
    // iterate over lines two at a time
    for (int i = 0; i < lines.length; i += 2) {
      String teamData = lines[i];
      String expectedScoreData = lines[i + 1];

      // create a new team and parse the team data into the team
      Team team = Team('Test Player');
      debugPrint('Parsing team data: $teamData');
      parseTeamData(team, teamData);

      // score the team
      debugPrint('Scoring team');
      Scorer.score(team);

      // parse the expected score data into a map of score type to expected score
      debugPrint('Parsing expected score data: $expectedScoreData');
      Score expectedScore = parseExpectedScoreData(expectedScoreData);

      // compare the team's score to the expected scores and print the results
      debugPrint('Comparing scores');
      bool scoresMatch = compareScores(team, expectedScore);
      if (!scoresMatch) {
        debugPrint('Test failed for team data: $teamData');
        // abort the test run if any test fails
        return;
      }
    }
  } catch (e) {
    debugPrint('error: $e');
  }
}

void parseTeamData(Team team, String teamData) {
  List<String> parts = teamData.split(';');
  for (String part in parts) {
    List<String> keyValue = part.split(':');
    String key = keyValue[0].trim();
    debugPrint('key: $key');
    String value = keyValue[1].trim();
    debugPrint('value: $value');

    switch (key) {
      case 'mng':
        team.manager = allManagers[int.parse(value) - 1];
        break;
      case 'k':
        List<int> keeperIndexList =
            value.split(',').map((s) => int.parse(s.trim()) - 1).toList();
        for (int index in keeperIndexList) {
          Player player = allKeepers[index];
          team.addPlayer(player, Position.keeper);
        }
        break;
      case 'd':
        List<int> playerIndexList =
            value.split(',').map((s) => int.parse(s.trim()) - 1).toList();
        for (int index in playerIndexList) {
          Player player = allPlayers[index];
          team.addPlayer(player, Position.defender);
        }
        break;
      case 'm':
        List<int> playerIndexList =
            value.split(',').map((s) => int.parse(s.trim()) - 1).toList();
        for (int index in playerIndexList) {
          Player player = allPlayers[index];
          team.addPlayer(player, Position.midfielder);
        }
        break;
      case 'f':
        List<int> playerIndexList =
            value.split(',').map((s) => int.parse(s.trim()) - 1).toList();
        for (int index in playerIndexList) {
          Player player = allPlayers[index];
          team.addPlayer(player, Position.forward);
        }
        break;
      case 'h':
        List<int> playerIndexList =
            value.split(',').map((s) => int.parse(s.trim()) - 1).toList();
        for (int index in playerIndexList) {
          Player player = allPlayers[index];
          team.addPlayer(player, Position.bench);
        }
        break;
      case 'tac':
        List<int> tacCardIndexList =
            value.split(',').map((s) => int.parse(s.trim()) - 1).toList();
        for (int index in tacCardIndexList) {
          TacCard tacCard = allTacCards[index];
          team.addTacCard(tacCard);
        }
        break;
      case 'mny':
        team.money = int.parse(value);
        break;
    }
  }
}

Score parseExpectedScoreData(String expectedScoreData) {
  Score expectedScore = Score();
  List<String> parts = expectedScoreData.split(';');
  for (String part in parts) {
    List<String> keyValue = part.split(':');
    String key = keyValue[0].trim();
    int value = int.parse(keyValue[1].trim());
    switch (key) {
      case 'mny':
        expectedScore.money = value;
        break;
      case 'tac':
        expectedScore.tacCards = value;
        break;
      case 'sp':
        expectedScore.speed = value;
        break;
      case 'sa':
        expectedScore.savvy = value;
        break;
      case 'st':
        expectedScore.strength = value;
        break;
      case 'sk':
        expectedScore.skill = value;
        break;
      case 'base':
        expectedScore.base = value;
        break;
    }

    expectedScore.total =
        expectedScore.money +
        expectedScore.tacCards +
        expectedScore.speed +
        expectedScore.savvy +
        expectedScore.strength +
        expectedScore.skill +
        expectedScore.base;
  }

  return expectedScore;
}

bool compareScores(Team team, Score expectedScore) {
  bool allMatch = true;
  if (team.score.money != expectedScore.money) {
    debugPrint(
      'Money score does not match. Expected ${expectedScore.money}, got ${team.score.money}',
    );
    allMatch = false;
  }
  if (team.score.tacCards != expectedScore.tacCards) {
    debugPrint(
      'TAC card score does not match. Expected ${expectedScore.tacCards}, got ${team.score.tacCards}',
    );
    allMatch = false;
  }
  if (team.score.speed != expectedScore.speed) {
    debugPrint(
      'Speed score does not match. Expected ${expectedScore.speed}, got ${team.score.speed}',
    );
    allMatch = false;
  }
  if (team.score.savvy != expectedScore.savvy) {
    debugPrint(
      'Savvy score does not match. Expected ${expectedScore.savvy}, got ${team.score.savvy}',
    );
    allMatch = false;
  }
  if (team.score.strength != expectedScore.strength) {
    debugPrint(
      'Strength score does not match. Expected ${expectedScore.strength}, got ${team.score.strength}',
    );
    allMatch = false;
  }
  if (team.score.skill != expectedScore.skill) {
    debugPrint(
      'Skill score does not match. Expected ${expectedScore.skill}, got ${team.score.skill}',
    );
    allMatch = false;
  }
  if (team.score.base != expectedScore.base) {
    debugPrint(
      'Base score does not match. Expected ${expectedScore.base}, got ${team.score.base}',
    );
    allMatch = false;
  }

  if (allMatch) {
    debugPrint('All scores match expected values!');
  }

  return allMatch;
}
