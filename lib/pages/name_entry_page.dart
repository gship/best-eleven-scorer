import 'package:flutter/material.dart';
import '../core.dart';
import '../routes.dart';
import '../team.dart';
import '../best_eleven_button.dart';
import '../main_contain.dart';
import '../last_players_db.dart';

class NameEntryPage extends StatefulWidget {
  const NameEntryPage({super.key});

  @override
  State<NameEntryPage> createState() => _NameEntryPageState();
}

class _NameEntryPageState extends State<NameEntryPage> {
  late List<TextEditingController> playerNameControllers;

  @override
  void initState() {
    super.initState();
    playerNameControllers = List.generate(
      core.numPlayers,
      (index) => TextEditingController(),
    );
    prepopulatePlayerNames();
  }

  void prepopulatePlayerNames() async {
    debugPrint('prepopulating player names');
    List<LastPlayers> lastPlayers = await lastPlayersDatabase.getLastPlayers();
    if (lastPlayers.isNotEmpty && lastPlayers[0].count == core.numPlayers) {
      if (core.numPlayers == 4) {
        playerNameControllers[3].text = lastPlayers[0].player4;
      }
      if (core.numPlayers >= 3) {
        playerNameControllers[2].text = lastPlayers[0].player3;
      }
      if (core.numPlayers >= 2) {
        playerNameControllers[1].text = lastPlayers[0].player2;
      }
      if (core.numPlayers >= 1) {
        playerNameControllers[0].text = lastPlayers[0].player1;
      }
    } else {
      await lastPlayersDatabase.clearLastPlayers();
    }
  }

  @override
  void dispose() {
    for (var controller in playerNameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Function to check if all player names are entered
  bool arePlayerNamesEntered() {
    for (var controller in playerNameControllers) {
      debugPrint('controller.text = ${controller.text}');
      debugPrint('controller.text.isEmpty = ${controller.text.isEmpty}');
      if (controller.text.isEmpty) {
        debugPrint('returning false');
        return false;
      }
    }

    debugPrint('returning true');
    return true;
  }

  void savePlayerNames() async {
    LastPlayers lastPlayers = LastPlayers();
    lastPlayers.count = core.numPlayers;
    if (core.numPlayers >= 1) {
      lastPlayers.player1 = playerNameControllers[0].text;
      teams.add(Team(playerNameControllers[0].text));
    }
    if (core.numPlayers >= 2) {
      lastPlayers.player2 = playerNameControllers[1].text;
      teams.add(Team(playerNameControllers[1].text));
    }
    if (core.numPlayers >= 3) {
      lastPlayers.player3 = playerNameControllers[2].text;
      teams.add(Team(playerNameControllers[2].text));
    }
    if (core.numPlayers == 4) {
      lastPlayers.player4 = playerNameControllers[3].text;
      teams.add(Team(playerNameControllers[3].text));
    }

    await lastPlayersDatabase.insertLastPlayers(lastPlayers);
  }

  @override
  Widget build(BuildContext context) {
    return mainContain(
      context,
      AssetImage('images/home.png'),
      content(context),
      true,
      false,
    );
  }

  Widget content(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 30),
          child: SizedBox(
            height: 100,
            child: Image(image: AssetImage('images/best_xi_logo.png')),
          ),
        ),
        SizedBox(
          //set a height
          height: MediaQuery.of(context).size.height / 4,
          child: SingleChildScrollView(
            child: Column(
              children: (List<Widget>.generate(core.numPlayers, (int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7.0),
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    style: const TextStyle(
                      fontFamily: 'Providence',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                      color: Colors.white,
                    ),
                    onChanged: (String str) {
                      debugPrint('text changed to $str');
                    },
                    onSubmitted: (String str) {
                      debugPrint('text submitted to $str');
                    },
                    controller: playerNameControllers[index],
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Player ${index + 1} Name',
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(width: 2, color: Colors.white),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(10),
                      ),

                      // Adjust radius for desired roundness
                      fillColor: Colors.black.withValues(alpha: 0.5),
                      filled: true,
                    ),
                  ),
                );
              }, growable: false)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Back button to go back to the Money page
            BestElevenButton(
              buttonText: 'BACK',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            // Next button to go to the next scoring category
            BestElevenButton(
              buttonText: 'NEXT',
              onPressed: () {
                debugPrint('NEXT button pressed');
                if (arePlayerNamesEntered()) {
                  savePlayerNames();
                  debugPrint(
                    'going to money page, current player = ${core.currentPlayer}',
                  );

                  // Navigate to the next page to start the game (or handle game logic)
                  Navigator.pushNamed(context, Routes.moneyEntryPage).then((_) {
                    debugPrint('I\'ve been popped name entry page');
                    teams.clear();
                  });
                } else {
                  debugPrint('not all names entered');
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
