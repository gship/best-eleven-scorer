import 'package:flutter/material.dart';
import '../name_tag.dart';
import '../core.dart';
import '../background_container.dart';
import '../team.dart';
import '../best_eleven_button.dart';
import '../routes.dart';
import '../player.dart';
import '../position.dart';

class AutomaTeamSelectPage extends StatefulWidget {
  const AutomaTeamSelectPage({super.key});

  @override
  State<AutomaTeamSelectPage> createState() => _AutomaTeamSelectPageState();
}

class _AutomaTeamSelectPageState extends State<AutomaTeamSelectPage> {
  List<int> selectedPlayers = List.empty(
    growable: true,
  ); // Holds the selected players indices

  @override
  void initState() {
    super.initState();
    if (core.inReview) {
      reset();
    }
  }

  void reset() {
    debugPrint(
      "In reset of AutomaTeamSelectPage, core.currentPlayer = ${core.currentPlayer}, count = ${teams[core.currentPlayer].players.length}",
    );
    // Initialize the selected players list from teams
    selectedPlayers.clear();
    for (var player in teams[core.currentPlayer].players) {
      // only add player if not a keeper
      if (!player.isKeeper) {
        debugPrint("Resetting player ${player.name}");
        selectedPlayers.add(player.index);
        // Reset the playing position of the player
        allPlayerStats[player.index].playingPosition = null;
        // Remove the player from core selected players
        core.selectedPlayers.remove(player);
      }
    }

    // Remove all players except keeper from team's players
    teams[core.currentPlayer].players.removeWhere(
      (element) => !element.isKeeper,
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Building AutomaTeamSelectPage inReview = ${core.inReview}");
    return backgroundContainer(
      context,
      AssetImage('images/background.webp'),
      content(context),
    );
  }

  bool isSelectable(int index) {
    Player player = allPlayers[index];
    return (selectedPlayers.contains(index) ||
        (selectedPlayers.length < 10 &&
            !core.selectedDefenders.contains(player) &&
            !core.selectedMidfielders.contains(player) &&
            !core.selectedForwards.contains(player) &&
            !core.playersInHand.contains(player)));
  }

  Widget content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          nameTag(teams[core.currentPlayer].gamePlayer),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('images/defender_icon.webp'), width: 50),
              Image(
                image: AssetImage('images/midfielder_icon.webp'),
                width: 50,
              ),
              Image(image: AssetImage('images/forward_icon.webp'), width: 50),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'SELECT PLAYERS',
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
              children: List.generate(allPlayers.length, (index) {
                return GestureDetector(
                  onTap:
                      isSelectable(index)
                          ? () {
                            setState(() {
                              // if already selected
                              if (selectedPlayers.contains(index)) {
                                // remove player
                                selectedPlayers.remove(index);
                              } else {
                                // add player
                                selectedPlayers.add(index);
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
                            selectedPlayers.contains(index)
                                ? Border.all(color: Colors.yellow, width: 2.5)
                                : null,
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      ),
                      child: Image.asset(
                        'images/players/${(allPlayers[index].index < 9) ? (allPlayers[index].index + 1).toString().padLeft(2, '0') : allPlayers[index].index + 1}.webp',
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
              // Back button to go back to the Money page
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
                  for (var index in selectedPlayers) {
                    Player player = allPlayers[index];
                    teams[core.currentPlayer].addPlayer(
                      player,
                      Position.player,
                    );
                    core.selectedPlayers.add(player);
                  }
                  if (core.inReview && !core.inManagerReset) {
                    Navigator.pop(context); // Go back to the review page
                  } else {
                    Navigator.pushNamed(context, reviewPage).then((_) {
                      debugPrint(
                        "Returned to players select page from review page, popping to root",
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
