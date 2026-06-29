import 'package:flutter/material.dart';
import '../core.dart';
import '../name_tag.dart';
import '../background_container.dart';
import '../team.dart';
import '../best_eleven_button.dart';
import '../routes.dart';
import '../player.dart';
import '../position.dart';

class ForwardsSelectPage extends StatefulWidget {
  const ForwardsSelectPage({super.key});

  @override
  State<ForwardsSelectPage> createState() => _ForwardsSelectPageState();
}

class _ForwardsSelectPageState extends State<ForwardsSelectPage> {
  List<int> selectedForwards = List.empty(
    growable: true,
  ); // Holds the selected defenders indices

  @override
  void initState() {
    super.initState();
    if (core.inReview) {
      reset();
    }
  }

  void reset() {
    // Initialize the selected forward list from teams
    debugPrint(
      "Resetting forwards select page, core.currentPlayer = ${core.currentPlayer}",
    ); //,  = teams[${core.currentPlayer}].forwards count = ${teams[core.currentPlayer].forwards.length}");
    selectedForwards.clear();
    for (var forward in teams[core.currentPlayer].forwards) {
      debugPrint("forward =  ${forward.name}");
      // Add team forward to the selected forwards
      selectedForwards.add(forward.forwardsIndex);
      // Reset the playing position of the forward
      allPlayerStats[forward.index].playingPosition = null;
    }
    debugPrint(
      "Selected forwards after reset: ${selectedForwards.map((index) => allForwards[index].name).join(', ')}",
    );
    // Clear the selected forward from teams
    teams[core.currentPlayer].forwards.clear();
    // Clear the selected forward from core
    core.selectedForwards.clear();
    debugPrint(
      "Selected forwards in core after reset: ${core.selectedForwards.map((player) => player.name).join(', ')}",
    );
  }

  bool isSelectable(int index) {
    Player player = allForwards[index];
    // debugPrint('selectedForwards.contains: ${selectedForwards.contains(index)}');
    logger.d('selectedForwards.length: ${selectedForwards.length}');
    // debugPrint('formation numberOfForwards: ${teams[core.currentPlayer].formation!.numberOfForwards}');
    // debugPrint('number of defenders: ${teams[core.currentPlayer].defenders.length}');
    logger.d('number of midfielders: ${teams[core.currentPlayer].midfielders.length}');
    logger.d('number of forwards: ${teams[core.currentPlayer].forwards.length}');
    // debugPrint('playersInHand contains player: ${core.playersInHand.contains(player)}');
    // debugPrint('selectedDefenders contains player: ${core.selectedDefenders.contains(player)}');
    // debugPrint('selectedMidfielders contains player: ${core.selectedMidfielders.contains(player)}');
    // debugPrint('selectedForwards contains player: ${core.selectedForwards.contains(player)}');
    return (selectedForwards.contains(index) ||
        ((selectedForwards.length <
                teams[core.currentPlayer].formation!.numberOfForwards) &&
            ((teams[core.currentPlayer].defenders.length +
                    teams[core.currentPlayer].midfielders.length +
                    selectedForwards.length) <
                10) &&
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
          Image(image: AssetImage('images/forward_icon.webp'), width: 50),
          const SizedBox(height: 20),
          const Text(
            'SELECT FORWARDS',
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
              children: List.generate(allForwards.length, (index) {
                return GestureDetector(
                  onTap:
                      isSelectable(index)
                          ? () {
                            setState(() {
                              // if already selected
                              if (selectedForwards.contains(index)) {
                                // remove forward
                                selectedForwards.remove(index);
                              } else {
                                // add forward
                                selectedForwards.add(index);
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
                            selectedForwards.contains(index)
                                ? Border.all(color: Colors.yellow, width: 2.5)
                                : null,
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      ),
                      child: Image.asset(
                        'images/players/${(allForwards[index].index < 9) ? (allForwards[index].index + 1).toString().padLeft(2, '0') : allForwards[index].index + 1}.webp',
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
                  for (var index in selectedForwards) {
                    Player player = allForwards[index];
                    teams[core.currentPlayer].addPlayer(
                      player,
                      Position.forward,
                    );
                    core.selectedForwards.add(player);
                  }
                  logger.d('selectedForwards.length: ${selectedForwards.length}');
                  logger.d('number of midfielders: ${teams[core.currentPlayer].midfielders.length}');
                  logger.d('number of defenders: ${teams[core.currentPlayer].defenders.length}');

                  if (core.inReview && !core.inManagerReset) {
                    Navigator.pop(context);
                  } else {
                    if (teams[core.currentPlayer].needPlayersInHand()) {
                      Navigator.pushNamed(
                        context,
                        playersInHandPage,
                      ).then((_) {
                        debugPrint(
                          "Returned from players in hand page, popping to root",
                        );
                        reset();
                      });
                    } else {
                      Navigator.pushNamed(context, reviewPage).then((_) {
                        debugPrint(
                          "Returned to forwards page from review page, popping to root",
                        );
                        reset();
                      });
                    }
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
