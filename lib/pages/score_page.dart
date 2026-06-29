import '../best_eleven_button.dart';
import 'package:flutter/material.dart';
import '../team.dart';
import '../scorer.dart';
import 'package:confetti/confetti.dart';
import '../high_scores.dart';
import '../routes.dart';
import '../save_game.dart';
import '../score_pad.dart';
import 'game_saved_confirmation_dialog.dart';
import '../core.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  bool scoresCalculated = false;
  bool hasHighScore = false;
  bool isSoloWin = false;
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
      Image(image: AssetImage('images/best_xi_logo.webp'), height: 80),
      const SizedBox(height: 20),
      scorePad(teams, MainAxisAlignment.center),
      const SizedBox(height: 15),
    ]);

    if (hasHighScore) {
      colList.add(
        BestElevenButton(
          buttonText: 'View High Scores',
          onPressed: () {
            Navigator.pushNamed(context, highScoresPage);
          },
        ),
      );
    }

    colList.add(const SizedBox(height: 15));

    // Buttons at the bottom
    if (!core.playingSolo) {
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
    }
    colList.add(
      BestElevenButton(
        buttonText: 'HOME',
        onPressed: () {
          debugPrint("Home button pressed, popping to root");
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
        debugPrint("Calculating score for ${team.gamePlayer}");
        if (team.isAutoma) {
          debugPrint("Team is Automa, using Automa scoring");
          Scorer.scoreAutoma(team);
          // if solo player's score is higher than automa's score
          if (teams[0].score.total > team.score.total) {
            isSoloWin = true;
            teams[0].score.isSoloWin = true;
          }
        } else {
          Scorer.score(team);
          if (!core.playingSolo) {
            team.score.isHighScore = await highScores.isHighScore(
              team.gamePlayer,
              team.score.total,
            );
            hasHighScore = hasHighScore || team.score.isHighScore;
          }
        }
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
    if (hasHighScore || isSoloWin) {
      confettiController.play();
    }

    return Scaffold(
      backgroundColor: const Color(0xff39b54a),
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          // Image set to background of the body
          image: DecorationImage(
            image: AssetImage('images/home.webp'),
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: content(hasHighScore || isSoloWin, confettiController),
          ),
        ),
      ),
    );
  }
}
