import 'package:flutter/material.dart';
import '../main_contain.dart';
import '../save_game.dart';
import '../saved_game.dart';
import '../routes.dart';
import '../best_eleven_button.dart';

class SavedGamesPage extends StatefulWidget {
  const SavedGamesPage({super.key});

  @override
  State<SavedGamesPage> createState() => _SavedGamesPageState();
}

class _SavedGamesPageState extends State<SavedGamesPage> {
  List<SavedGame> savedGames = [];
  int _savedGameId = 0;

  @override
  void initState() {
    super.initState();
    getSavedGames();
  }

  getSavedGames() async {
    debugPrint('getSavedGames()');
    savedGames = await saveGame.getSavedGames();
    setState(() {});
    _savedGameId = 0;
  }

  bool isSelectable() {
    return (_savedGameId == 0);
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            'SAVED GAMES',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Tap to select...',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: savedGames.length,
              itemBuilder: (context, index) {
                debugPrint('saved game id: ${savedGames[index].savedGameId}');
                debugPrint('selected saved game id: $_savedGameId');
                return Card(
                  shape:
                      (_savedGameId == 0 ||
                              _savedGameId != savedGames[index].savedGameId)
                          ? RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )
                          : RoundedRectangleBorder(
                            side: BorderSide(color: Colors.yellow, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                  color: Colors.black.withValues(alpha: 0.5),
                  child: ListTile(
                    title: Text(
                      savedGames[index].toValuesString(),
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      debugPrint(
                        'I\'ve been tapped, saved game id: ${savedGames[index].savedGameId}',
                      );
                      _savedGameId = savedGames[index].savedGameId;
                      debugPrint('selected saved game id: $_savedGameId');
                      setState(() {});
                    },
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
              // View Saved Game and Delete Saved Game
              // Next button to go to the next scoring category
              BestElevenButton(
                buttonText: 'View Saved Game',
                onPressed: () {
                  if (_savedGameId == 0) return;
                  savedGameId = _savedGameId;
                  Navigator.pushNamed(context, Routes.savedGamePage).then((_) {
                    debugPrint('I\'ve been popped saved games page');
                    _savedGameId = savedGameId;
                    debugPrint('set saved game id to $_savedGameId');
                  });
                },
              ),
              const SizedBox(height: 20),
              BestElevenButton(
                buttonText: 'Delete Saved Game',
                onPressed: () {
                  if (_savedGameId == 0) return;
                  saveGame.deleteSavedGame(_savedGameId);
                  _savedGameId = 0;
                  getSavedGames();
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              // Back button to go back to the Money page
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
