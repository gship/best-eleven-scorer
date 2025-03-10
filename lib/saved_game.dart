int savedGameId = 0;

class SavedGame {
  int savedGameId;
  int numPlayers;
  String date;
  String player1 = '';
  int player1Score = 0;
  String player2 = '';
  int player2Score = 0;
  String player3 = '';
  int player3Score = 0;
  String player4 = '';
  int player4Score = 0;

  SavedGame({
    required this.savedGameId,
    required this.numPlayers,
    required this.date,
    this.player1 = '',
    this.player1Score = 0,
    this.player2 = '',
    this.player2Score = 0,
    this.player3 = '',
    this.player3Score = 0,
    this.player4 = '',
    this.player4Score = 0,
  });

  String toValuesString() {
    String values = '$date, $player1, $player1Score';
    if (player2.isNotEmpty) values += ', $player2, $player2Score';
    if (player3.isNotEmpty) values += ', $player3, $player3Score';
    if (player4.isNotEmpty) values += ', $player4, $player4Score';
    return values;
  }
}

class SavedTeam {
  String gamePlayer;
  int manager;
  int keeper;
  int money;
  int tacCards;
  int scoreMoney;
  int speed;
  int savvy;
  int strength;
  int skill;
  int base;
  int total;
  bool isHighScore;

  SavedTeam({
    required this.gamePlayer,
    required this.manager,
    required this.keeper,
    required this.money,
    required this.tacCards,
    required this.scoreMoney,
    required this.speed,
    required this.savvy,
    required this.strength,
    required this.skill,
    required this.base,
    required this.total,
    required this.isHighScore,
  });

  String players() {
    return '($gamePlayer, $manager, $keeper, $money, $tacCards, $scoreMoney, $speed, $savvy, $strength, $skill, $base, $total, $isHighScore)';
  }
}

class SavedInteger {
  int integer;

  SavedInteger({required this.integer});
}
