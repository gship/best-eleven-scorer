import 'package:flutter/material.dart';
import '../name_tag.dart';
import '../core.dart';
import '../background_container.dart';
import '../team.dart';
import '../best_eleven_button.dart';
import '../routes.dart';
import '../player.dart';
import '../position.dart';

const _nextRoutes = {
  Position.defender: midfieldersSelectPage,
  Position.midfielder: forwardsSelectPage,
  Position.forward: reviewPage,
};

class PlayersSelectPage extends StatefulWidget {
  final Position position;

  const PlayersSelectPage({super.key, required this.position});

  @override
  State<PlayersSelectPage> createState() => _PlayersSelectPageState();
}

class _PlayersSelectPageState extends State<PlayersSelectPage> {
  List<int> selectedPlayers = List.empty(
    growable: true,
  ); // Holds the selected players indices

  final _allPlayersAtPosition = {
    Position.defender: allDefenders,
    Position.midfielder: allMidfielders,
    Position.forward: allForwards,
  };

  final _positionIcons = {
    Position.defender: 'images/defender_icon.webp',
    Position.midfielder: 'images/midfielder_icon.webp',
    Position.forward: 'images/forward_icon.webp',
  };

  final _positionSelect = {
    Position.defender: 'SELECT DEFENDERS',
    Position.midfielder: 'SELECT MIDFIELDERS',
    Position.forward: 'SELECT FORWARDS',
  };

  @override
  void initState() {
    super.initState();
    if (core.inReview) {
      reset();
    }
  }

  void reset() {
    // Initialize the selected players list from teams
    selectedPlayers.clear();
    List<Player> players = teams[core.currentPlayer].getPlayersAtPosition(
      widget.position,
    );
    for (var player in players) {
      // Add team player to the selected players
      selectedPlayers.add(player.getPositionIndex(widget.position));
      // Reset the playing position of the player
      allPlayerStats[player.index].playingPosition = null;
      // Remove the selected player from core players at that position
      core.removePlayerAtPosition(player, widget.position);
    }
    // Clear the team's players at the position
    teams[core.currentPlayer].clearPlayersAtPosition(widget.position);
  }

  bool isSelectable(int index) {
    Player player = _allPlayersAtPosition[widget.position]![index];
    return (selectedPlayers.contains(index) ||
        (teams[core.currentPlayer].canAddPlayerAtPosition(
              selectedPlayers.length,
              widget.position,
            ) &&
            !core.selectedDefenders.contains(player) &&
            !core.selectedMidfielders.contains(player) &&
            !core.selectedForwards.contains(player) &&
            !core.playersInHand.contains(player)));
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
          Image(image: AssetImage(_positionIcons[widget.position]!), width: 50),
          const SizedBox(height: 20),
          Text(
            _positionSelect[widget.position]!,
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
              children: List.generate(
                _allPlayersAtPosition[widget.position]!.length,
                (index) {
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
                          'images/players/${(_allPlayersAtPosition[widget.position]![index].index < 9) ? (_allPlayersAtPosition[widget.position]![index].index + 1).toString().padLeft(2, '0') : _allPlayersAtPosition[widget.position]![index].index + 1}.webp',
                        ),
                      ),
                    ),
                  );
                },
              ),
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
                    Player player =
                        _allPlayersAtPosition[widget.position]![index];
                    teams[core.currentPlayer].addPlayer(
                      player,
                      widget.position,
                    );
                    core.addPlayerAtPosition(player, widget.position);
                  }

                  if (core.inReview && !core.inManagerReset) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushNamed(
                      context,
                      _nextRoutes[widget.position]!,
                    ).then((_) {
                      debugPrint(
                        "Returned to ${_positionSelect[widget.position]} page, popping to root",
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
