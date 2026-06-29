import 'package:sqflite/sqflite.dart';
import 'high_score.dart';
import 'best_xi_db.dart';

HighScoresDatabase highScoresDatabase = HighScoresDatabase();

class HighScoresDatabase {
  Future<int> insertHighScore(HighScore highScore) async {
    Database db = await bestXiDatabase.getDb();
    return await db.insert('high_scores', highScore.toMap());
  }

  Future<List<HighScore>> getHighScores() async {
    Database db = await bestXiDatabase.getDb();
    final List<Map<String, Object?>> highScores = await db.query('high_scores');
    return [
      for (final {
            'id': id as int,
            'date': date as String,
            'player': player as String,
            'score': score as int,
          }
          in highScores)
        HighScore(id: id, date: date, player: player, score: score),
    ];
  }

  Future<int> updateHighScore(HighScore highScore) async {
    Database db = await bestXiDatabase.getDb();
    return await db.update(
      'high_scores',
      highScore.toMap(),
      where: 'id = ?',
      whereArgs: [highScore.id],
    );
  }

  Future<int> deleteHighScore(int id) async {
    Database db = await bestXiDatabase.getDb();
    return await db.delete('high_scores', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteHighScores() async {
    Database db = await bestXiDatabase.getDb();
    return await db.delete('high_scores');
  }

  Future<void> bulkInsert(String valuesString) async {
    Database db = await bestXiDatabase.getDb();
    await db.rawInsert(
      'insert into high_scores (id, date, player, score) values $valuesString',
    );
  }
}
