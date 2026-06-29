import 'package:flutter/material.dart';
import '../core.dart';
import '../background_container.dart';
import '../team.dart';
import '../best_eleven_button.dart';
import '../routes.dart';
import '../player.dart';
import '../position.dart';
import '../name_tag.dart';

class PlayersInHandPage extends StatefulWidget {
  const PlayersInHandPage({super.key});

  @override
  State<PlayersInHandPage> createState() => _PlayersInHandPageState();
}

class _PlayersInHandPageState extends State<PlayersInHandPage> {
  List<int> playersInHand = List.empty(
    growable: true,
  ); // Holds the selected player indices

  @override
  void initState() {
    super.initState();
    if (core.inReview) {
      reset();
    }
  }

  void reset() {
    // Initialize the playersInHand list from teams
    playersInHand.clear();
    for (var player in teams[core.currentPlayer].hand) {
      playersInHand.add(player.index);
      // Reset the position of the player
      allPlayerStats[player.index].playingPosition = null;
      // Remove the selected defender from core
      core.playersInHand.remove(player);
    }
    // Clear the team's bench
    teams[core.currentPlayer].hand.clear();
  }

  bool isSelectable(int index) {
    Player player = allPlayers[index];
    return (playersInHand.contains(index) ||
        !core.selectedDefenders.contains(player) &&
            !core.selectedMidfielders.contains(player) &&
            !core.selectedForwards.contains(player) &
                !core.playersInHand.contains(player));
  }

  @override
  Widget build(BuildContext context) {
    return backgroundContainer(
      context,
      AssetImage('images/background.webp'),
      content(context),
    );
  }

  Widget content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          nameTag(teams[core.currentPlayer].gamePlayer),
          Image(
            image: AssetImage('images/blank_position_icon.webp'),
            width: 50,
          ),
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
              crossAxisCount: 4,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              //shrinkWrap: true,
              children: List.generate(allPlayers.length, (index) {
                return GestureDetector(
                  onTap:
                      isSelectable(index)
                          ? () {
                            setState(() {
                              // if already selected
                              if (playersInHand.contains(index)) {
                                // remove player
                                playersInHand.remove(index);
                              } else {
                                // add player
                                playersInHand.add(index);
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
                                ? Border.all(color: Colors.yellow, width: 2.5)
                                : null,
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      ),
                      child: Image.asset(
                        'images/players/${(allPlayers[index].index < 9) ? (allPlayers[index].index + 1).toString().padLeft(2, '0') : allPlayers[index].index + 1}.webp',
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
                onPressed:
                    core.inReview
                        ? null
                        : () {
                          Navigator.pop(
                            context,
                          ); // Go back to the previous page
                        },
              ),
              // Next button to go to the next scoring category
              BestElevenButton(
                buttonText: 'NEXT',
                onPressed: () {
                  for (var index in playersInHand) {
                    Player player = allPlayers[index];
                    teams[core.currentPlayer].addPlayer(player, Position.bench);
                    core.playersInHand.add(player);
                  }

                  if (core.inReview && !core.inManagerReset) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushNamed(context, reviewPage).then((_) {
                      debugPrint(
                        "Returned to players in hand page from review page, popping to root",
                      );
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
