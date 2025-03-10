import 'high_score.dart';
import 'high_scores_db.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

HighScores highScores = HighScores();

class HighScores {
  List<HighScore> highScores = [];

  initialize() async {
    highScores = await highScoresDatabase.getHighScores();
    for (var highScore in highScores) {
      debugPrint(highScore.toString());
    }
    debugPrint('highScores.length = ${highScores.length}');
  }

  Future<bool> isHighScore(String player, int score) async {
    bool retVal = false;
    String valuesString = '';

    debugPrint('in isHighScore, highScores.length = ${highScores.length}');

    for (var highScore in highScores) {
      debugPrint(highScore.toString());
    }

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM yyyy').format(now);
    HighScore temp = HighScore(
      id: 0,
      date: formattedDate,
      player: player,
      score: score,
    );

    for (var highScore in highScores) {
      if (score > highScore.score) {
        retVal = true;
        await highScoresDatabase.deleteHighScores();
        HighScore previous = highScore;
        temp.id = highScore.id;
        debugPrint('overwriting high score at ${highScore.id}');
        highScores[highScore.id - 1] = temp;
        valuesString += temp.toValueString();
        temp = previous;

        // push down the rest of the scores
        for (int i = highScore.id; i < highScores.length; ++i) {
          HighScore previous = highScores[i];
          temp.id = i + 1;
          debugPrint('overwriting high score at ${temp.id}');
          highScores[i] = temp;
          valuesString += temp.toValueString();
          temp = previous;
        }

        if (temp.id < 11) {
          temp.id++;
          debugPrint('inserting previous high score at ${temp.id}');
          highScores.add(temp);
          valuesString += temp.toValueString();
        }

        await highScoresDatabase.bulkInsert(valuesString);
        break;
      } else {
        valuesString += highScore.toValueString();
      }
    }

    if (!retVal && highScores.length < 11) {
      retVal = true;
      temp.id = highScores.length + 1;
      debugPrint('inserting new high score at ${temp.id}');
      await highScoresDatabase.insertHighScore(temp);
      highScores.add(temp);
    }

    if (retVal) {}

    debugPrint('returning isHighScore $retVal');
    return retVal;
  }

  deleteHighScores() async {
    await highScoresDatabase.deleteHighScores();
    highScores = [];
  }

  void debugPrintHighScores() {
    for (var highScore in highScores) {
      debugPrint(highScore.toString());
    }
  }
}
