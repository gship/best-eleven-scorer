import 'package:best_xi_scorer/best_eleven_button.dart';
import 'package:flutter/material.dart';
import '../team.dart';
import '../scorer.dart';
import 'package:confetti/confetti.dart';
import '../high_scores.dart';
import '../routes.dart';
import '../save_game.dart';
import '../score_pad.dart';
import 'game_saved_confirmation_dialog.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  bool scoresCalculated = false;
  bool hasHighScore = false;
  bool gameSaved = false;

  @override
  void initState() {
    super.initState();
  }

  List<Widget> content(
    bool showConfetti,
    ConfettiController confettiController,
  ) {
    List<Widget> retList = [];
    List<Widget> colList = [];
    List<Widget> stackList = [];

    retList.addAll([const SizedBox(height: 50)]);

    colList.addAll([
      Image(image: AssetImage('images/best_xi_logo.png'), height: 80),
      const SizedBox(height: 20),
      scorePad(teams, MainAxisAlignment.center),
      const SizedBox(height: 15),
    ]);

    if (hasHighScore) {
      colList.add(
        BestElevenButton(
          buttonText: 'View High Scores',
          onPressed: () {
            Navigator.pushNamed(context, Routes.highScoresPage);
          },
        ),
      );
    }

    colList.add(const SizedBox(height: 15));

    // Buttons at the bottom
    colList.add(
      BestElevenButton(
        buttonText: 'Save Game',
        onPressed: () {
          if (!gameSaved) {
            gameSaved = true;
            saveGame.saveGame();
            showGameSavedConfirmationDialog(context);
          }
        },
      ),
    );
    colList.add(const SizedBox(height: 15));
    colList.add(
      BestElevenButton(
        buttonText: 'BACK',
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
    colList.add(const SizedBox(height: 15));
    // Home button
    colList.add(
      BestElevenButton(
        buttonText: 'HOME',
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
    );
    colList.add(const SizedBox(height: 15));

    Column column = Column(children: colList);

    stackList.add(column);

    if (showConfetti) {
      stackList.add(
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            emissionFrequency: 0.04,
            numberOfParticles: 20,
            confettiController: confettiController,
            // don't specify a direction, blast randomly
            blastDirectionality: BlastDirectionality.explosive,
            // start again as soon as the animation is finished
            shouldLoop: false,
            // manually specify the colors to be used
            colors: const [Colors.yellow],
          ),
        ),
      );
    }

    Stack stack = Stack(children: stackList);

    retList.add(stack);

    return retList;
  }

  void calculateScores() async {
    if (!scoresCalculated) {
      for (var team in teams) {
        Scorer.score(team);
        debugPrint('Score for ${team.gamePlayer}....');
        debugPrint('-----------------------------------------');
        debugPrint('TacCard score = ${team.score.tacCards}');
        debugPrint('Money = ${team.score.money}');
        debugPrint('Speed = ${team.score.speed}');
        debugPrint('Savvy = ${team.score.savvy}');
        debugPrint('Strength = ${team.score.strength}');
        debugPrint('Skill = ${team.score.skill}');
        debugPrint('Base = ${team.score.base}');
        debugPrint('Total = ${team.score.total}');
        debugPrint('-----------------------------------------');
        team.score.isHighScore = await highScores.isHighScore(
          team.gamePlayer,
          team.score.total,
        );
        hasHighScore = hasHighScore || team.score.isHighScore;

        debugPrint('isHighScore = $hasHighScore');
      }

      scoresCalculated = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final ConfettiController confettiController = ConfettiController(
      duration: const Duration(seconds: 10),
    );

    calculateScores();

    // check if any score is a high score
    if (hasHighScore) {
      debugPrint('trying to play confetti...');
      confettiController.play();
      highScores.debugPrintHighScores();
    }

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          // Image set to background of the body
          image: DecorationImage(
            image: AssetImage('images/background.png'),
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(children: content(hasHighScore, confettiController)),
        ),
      ),
    ); //,
    //);
  }
}
