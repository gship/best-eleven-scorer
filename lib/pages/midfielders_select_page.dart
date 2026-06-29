import '../name_tag.dart';
import 'package:flutter/material.dart';
import '../core.dart';
import '../background_container.dart';
import '../team.dart';
import '../best_eleven_button.dart';
import '../routes.dart';
import '../player.dart';
import '../position.dart';

class MidfieldersSelectPage extends StatefulWidget {
  const MidfieldersSelectPage({super.key});

  @override
  State<MidfieldersSelectPage> createState() => _MidfieldersSelectPageState();
}

class _MidfieldersSelectPageState extends State<MidfieldersSelectPage> {
  List<int> selectedMidfielders = List.empty(
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
    // Initialize the selected midfielder list from teams
    selectedMidfielders.clear();
    for (var midfielder in teams[core.currentPlayer].midfielders) {
      // Add team midfielder to the selected midfielders
      selectedMidfielders.add(midfielder.midfieldersIndex);
      // Reset the playing position of the midfielder
      allPlayerStats[midfielder.index].playingPosition = null;
      // Remove the midfielder from core selected midfielders
      core.selectedMidfielders.remove(midfielder);
    }
    // Clear the team's midfielders
    teams[core.currentPlayer].midfielders.clear();
  }

  bool isSelectable(int index) {
    Player player = allMidfielders[index];
    // debugPrint('selectedMidfielders.contains: ${selectedMidfielders.contains(index)}');
    logger.d('selectedMidfielders.length: ${selectedMidfielders.length}');
    // debugPrint('formation numberOfMidfielders: ${teams[core.currentPlayer].formation!.numberOfMidfielders}');
    logger.d('number of defenders: ${teams[core.currentPlayer].defenders.length}');
    logger.d('number of forwards: ${teams[core.currentPlayer].forwards.length}');
    // debugPrint('playersInHand contains player: ${core.playersInHand.contains(player)}');
    // debugPrint('selectedDefenders contains player: ${core.selectedDefenders.contains(player)}');
    // debugPrint('selectedMidfielders contains player: ${core.selectedMidfielders.contains(player)}');
    // debugPrint('selectedForwards contains player: ${core.selectedForwards.contains(player)}');
    return (selectedMidfielders.contains(index) ||
        (selectedMidfielders.length <
                teams[core.currentPlayer].formation!.numberOfMidfielders &&
            (teams[core.currentPlayer].defenders.length +
                    selectedMidfielders.length +
                    teams[core.currentPlayer].forwards.length) <
                10 &&
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
          Image(image: AssetImage('images/midfielder_icon.webp'), width: 50),
          const SizedBox(height: 20),
          const Text(
            'SELECT MIDFIELDERS',
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
              children: List.generate(allMidfielders.length, (index) {
                return GestureDetector(
                  onTap:
                      isSelectable(index)
                          ? () {
                            setState(() {
                              // if already selected
                              if (selectedMidfielders.contains(index)) {
                                // remove midfielder
                                selectedMidfielders.remove(index);
                              } else {
                                // add midfielder
                                selectedMidfielders.add(index);
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
                            selectedMidfielders.contains(index)
                                ? Border.all(color: Colors.yellow, width: 2.5)
                                : null,
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      ),
                      child: Image.asset(
                        'images/players/${(allMidfielders[index].index < 9) ? (allMidfielders[index].index + 1).toString().padLeft(2, '0') : allMidfielders[index].index + 1}.webp',
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
                  for (var index in selectedMidfielders) {
                    Player player = allMidfielders[index];
                    teams[core.currentPlayer].addPlayer(
                      player,
                      Position.midfielder,
                    );
                    core.selectedMidfielders.add(player);
                  }
                  logger.d('selectedMidfielders.length: ${selectedMidfielders.length}');
                  logger.d('number of defenders: ${teams[core.currentPlayer].defenders.length}');
                  logger.d('number of forwards: ${teams[core.currentPlayer].forwards.length}');

                  if (core.inReview && !core.inManagerReset) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushNamed(
                      context,
                      forwardsSelectPage,
                    ).then((_) {
                      debugPrint(
                        "Returned from forwards select page, popping to root",
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
