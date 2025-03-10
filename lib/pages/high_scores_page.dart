import 'package:flutter/material.dart';
import '../high_scores.dart';
import '../best_eleven_button.dart';
import '../main_contain.dart';
import 'clear_high_scores_confirmation_dialog.dart';

class HighScoresPage extends StatefulWidget {
  const HighScoresPage({super.key});

  @override
  State<HighScoresPage> createState() => _HighScoresPageState();
}

class _HighScoresPageState extends State<HighScoresPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return mainContain(
      context,
      AssetImage('images/background.png'),
      content(context),
      false,
      true,
    );
  }

  Widget content(BuildContext context) {
    debugPrint('building HighScoresPage');

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'HIGH SCORES',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: highScores.highScores.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.black.withValues(alpha: 0.5),
                  child: ListTile(
                    title: Text(
                      highScores.highScores[index].toString(),
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Buttons at the bottom
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Back button
              BestElevenButton(
                buttonText: 'Reset High Scores',
                onPressed: () async {
                  bool? clearHighScores =
                      await showClearHighScoresConfirmationDialog(context);
                  debugPrint('clearHighScores = $clearHighScores');
                  if (clearHighScores) {
                    await highScores.deleteHighScores();
                  }
                  debugPrint(
                    'highScores.length = ${highScores.highScores.length}',
                  );
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              // Back button
              BestElevenButton(
                buttonText: 'BACK',
                onPressed: () {
                  Navigator.pop(
                    context,
                  ); // Assuming you want to go back to the previous page
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
