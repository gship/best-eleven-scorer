class HighScore {
  int id;
  String date;
  String player;
  int score;

  HighScore({
    required this.id,
    required this.date,
    required this.player,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date, 'player': player, 'score': score};
  }

  factory HighScore.fromMap(Map<String, dynamic> map) {
    return HighScore(
      id: map['id'],
      date: map['date'],
      player: map['player'],
      score: map['score'],
    );
  }

  String toValueString() {
    if (id == 1) {
      return toValuesString();
    } else {
      return ',${toValuesString()}';
    }
  }

  String toValuesString() {
    return '($id, \'$date\', \'$player\', $score)';
  }

  @override
  String toString() {
    return '$id - $player, $score, $date';
  }
}
