import 'package:flutter/material.dart';
import '../high_scores_db.dart';
import '../high_score.dart';
import 'package:intl/intl.dart';
import '../core.dart';

void main() async {
  // Initialize the database and insert users
  WidgetsFlutterBinding.ensureInitialized();
  initialize();

  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  HighScore glen = HighScore(
    id: 1,
    date: formattedDate,
    player: 'Glen',
    score: 127,
  );
  HighScore sheila = HighScore(
    id: 2,
    date: formattedDate,
    player: 'Sheila',
    score: 120,
  );
  HighScore matt = HighScore(
    id: 3,
    date: formattedDate,
    player: 'Matt',
    score: 100,
  );
  HighScore brig = HighScore(
    id: 4,
    date: formattedDate,
    player: 'Brigham',
    score: 97,
  );
  HighScore jeho = HighScore(
    id: 5,
    date: formattedDate,
    player: 'Jehosaphat',
    score: 93,
  );
  HighScore gmf = HighScore(
    id: 6,
    date: formattedDate,
    player: 'Grandmaster Funk',
    score: 91,
  );
  await highScoresDatabase.deleteHighScores();
  debugPrint('inserting high scores');

  int timeStart = DateTime.now().millisecondsSinceEpoch;
  await highScoresDatabase.insertHighScore(glen);
  await highScoresDatabase.insertHighScore(sheila);
  await highScoresDatabase.insertHighScore(matt);
  await highScoresDatabase.insertHighScore(brig);
  await highScoresDatabase.insertHighScore(jeho);
  await highScoresDatabase.insertHighScore(gmf);
  int timeEnd = DateTime.now().millisecondsSinceEpoch;
  debugPrint('individual inserts took ${timeEnd - timeStart} mSec');
  await highScoresDatabase.deleteHighScores();

  timeStart = DateTime.now().millisecondsSinceEpoch;
  String valuesString = glen.toValuesString();
  valuesString += ',${sheila.toValuesString()}';
  valuesString += ',${matt.toValuesString()}';
  valuesString += ',${brig.toValuesString()}';
  valuesString += ',${jeho.toValuesString()}';
  valuesString += ',${gmf.toValuesString()}';

  await highScoresDatabase.bulkInsert(valuesString);
  timeEnd = DateTime.now().millisecondsSinceEpoch;
  debugPrint('bulkInsert took ${timeEnd - timeStart} mSec');

  debugPrint('inserted high scores');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HighScores',
      home: HighScoresList(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HighScoresList extends StatefulWidget {
  const HighScoresList({super.key});

  @override
  HighScoresListState createState() => HighScoresListState();
}

class HighScoresListState extends State<HighScoresList> {
  List<HighScore> _highScores = [];

  @override
  void initState() {
    super.initState();
    _fetchHighScores();
  }

  Future<void> _fetchHighScores() async {
    final highScores = await highScoresDatabase.getHighScores();
    for (var highScore in highScores) {
      debugPrint(highScore.toString());
    }
    setState(() {
      _highScores = highScores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('High Scores'),
        backgroundColor: Colors.lightGreen,
      ),
      body: ListView.builder(
        itemCount: _highScores.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              _highScores[index].toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontFamily: 'Providence',
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
