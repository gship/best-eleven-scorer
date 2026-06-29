import 'high_score.dart';
import 'high_scores_db.dart';
import 'package:intl/intl.dart';

HighScores highScores = HighScores();

class HighScores {
  List<HighScore> highScores = [];

  Future<void> initialize() async {
    highScores = await highScoresDatabase.getHighScores();
  }

  Future<bool> isHighScore(String player, int score) async {
    bool retVal = false;
    String valuesString = '';

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
        highScores[highScore.id - 1] = temp;
        valuesString += temp.toValueString();
        temp = previous;

        // push down the rest of the scores
        for (int i = highScore.id; i < highScores.length; ++i) {
          HighScore previous = highScores[i];
          temp.id = i + 1;
          highScores[i] = temp;
          valuesString += temp.toValueString();
          temp = previous;
        }

        if (temp.id < 11) {
          temp.id++;
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
      await highScoresDatabase.insertHighScore(temp);
      highScores.add(temp);
    }

    return retVal;
  }

  Future<void> deleteHighScores() async {
    await highScoresDatabase.deleteHighScores();
    highScores = [];
  }
}
