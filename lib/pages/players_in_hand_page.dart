import 'package:best_xi_scorer/name_tag.dart';
import 'package:flutter/material.dart';
import '../core.dart';
import '../main_contain.dart';
import '../team.dart';
import '../best_eleven_button.dart';
import '../routes.dart';
import '../player.dart';
import '../position.dart';

class PlayersInHandPage extends StatefulWidget {
  const PlayersInHandPage({super.key});

  @override
  State<PlayersInHandPage> createState() => _PlayersInHandPageState();
}

class _PlayersInHandPageState extends State<PlayersInHandPage> {
  List<int> playersInHand = List.empty(
    growable: true,
  ); // Holds the selected player indices
  bool savedPlayersInHand = false;

  @override
  void initState() {
    super.initState();
  }

  void reset() {
    // Initialize the playersInHand list from teams
    playersInHand.clear();
    for (var player in teams[core.currentPlayer].hand) {
      playersInHand.add(player.benchIndex);
      // Reset the position of the player
      player.playingPosition = null;
      // Remove the selected defender from core
      core.playersInHand.remove(player);
    }
    // Clear the team's bench
    teams[core.currentPlayer].hand.clear();
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

  bool isSelectable(int index) {
    Player player = allPlayers[index];
    return (playersInHand.contains(index) ||
        !core.selectedDefenders.contains(player) &&
            !core.selectedMidfielders.contains(player) &&
            !core.selectedForwards.contains(player) &
                !core.playersInHand.contains(player));
  }

  Widget content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          nameTag(teams[core.currentPlayer].gamePlayer),
          const SizedBox(height: 20),
          Image(image: AssetImage('images/blank_position_icon.png'), width: 50),
          const SizedBox(height: 20),
          const Text(
            'SELECT PLAYERS IN HAND',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              //shrinkWrap: true,
              children: List.generate(allPlayers.length, (index) {
                return GestureDetector(
                  onTap:
                      isSelectable(index)
                          ? () {
                            setState(() {
                              if (playersInHand.contains(index)) {
                                playersInHand.remove(
                                  index,
                                ); // Deselect if already selected
                              } else {
                                playersInHand.add(index); // Select player
                              }
                            });
                          }
                          : null,
                  child: AnimatedOpacity(
                    opacity: isSelectable(index) ? 1.0 : 0.4,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        border:
                            playersInHand.contains(index)
                                ? Border.all(color: Colors.yellow, width: 2.0)
                                : null,
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Image.asset(
                        'images/players/${(allPlayers[index].index < 9) ? (allPlayers[index].index + 1).toString().padLeft(2, '0') : allPlayers[index].index + 1}.png',
                        width: 20, // Adjust image size
                        height: 20,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 20),
          // Buttons at the bottom
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Back button to go back to previous page
              BestElevenButton(
                buttonText: 'BACK',
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous page
                },
              ),
              // Next button to go to the next scoring category
              BestElevenButton(
                buttonText: 'NEXT',
                onPressed: () {
                  if (!savedPlayersInHand) {
                    for (var temp in playersInHand) {
                      Player player = allPlayers[temp];
                      teams[core.currentPlayer].addPlayer(
                        player,
                        Position.bench,
                      );
                      core.playersInHand.add(player);
                    }

                    savedPlayersInHand = true;
                  }
                  if (core.currentPlayer < (core.numPlayers - 1)) {
                    // more players
                    ++core.currentPlayer;
                    Navigator.pushNamed(context, Routes.moneyEntryPage).then((
                      _,
                    ) {
                      debugPrint('I\'ve been popped players in hand page');
                      --core.currentPlayer;
                      reset();
                    });
                  } else {
                    // last or only player
                    Navigator.pushNamed(context, Routes.scorePage).then((_) {
                      debugPrint('I\'ve been popped players in hand page');
                      reset();
                    });
                  }
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
