import 'package:flutter/material.dart';
import '../name_tag.dart';
import '../core.dart';
import '../background_container.dart';
import '../team.dart';
import '../best_eleven_button.dart';
import '../routes.dart';
import '../player.dart';
import '../position.dart';

class DefendersSelectPage extends StatefulWidget {
  const DefendersSelectPage({super.key});

  @override
  State<DefendersSelectPage> createState() => _DefendersSelectPageState();
}

class _DefendersSelectPageState extends State<DefendersSelectPage> {
  List<int> selectedDefenders = List.empty(
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
    // Initialize the selected defender list from teams
    selectedDefenders.clear();
    for (var defender in teams[core.currentPlayer].defenders) {
      // Add team defender to the selected defenders
      selectedDefenders.add(defender.defendersIndex);
      // Reset the playing position of the defender
      allPlayerStats[defender.index].playingPosition = null;
      // Remove the selected defender from core
      core.selectedDefenders.remove(defender);
    }
    // Clear the team's defenders
    teams[core.currentPlayer].defenders.clear();
  }

  bool isSelectable(int index) {
    Player player = allDefenders[index];
    // debugPrint('selectedDefenders.contains: ${selectedDefenders.contains(index)}');
    logger.d('selectedDefenders.length: ${selectedDefenders.length}');
    // debugPrint('formation numberOfDefenders: ${teams[core.currentPlayer].formation!.numberOfDefenders}');
    logger.d('number of midfielders: ${teams[core.currentPlayer].midfielders.length}');
    logger.d('number of forwards: ${teams[core.currentPlayer].forwards.length}');
    // debugPrint('total selected players: ${selectedDefenders.length + teams[core.currentPlayer].midfielders.length + teams[core.currentPlayer].forwards.length}');
    // debugPrint('playersInHand contains player: ${core.playersInHand.contains(player)}');
    // debugPrint('selectedDefenders contains player: ${core.selectedDefenders.contains(player)}');
    // debugPrint('selectedMidfielders contains player: ${core.selectedMidfielders.contains(player)}');
    // debugPrint('selectedForwards contains player: ${core.selectedForwards.contains(player)}');
    return (selectedDefenders.contains(index) ||
        (selectedDefenders.length <
                teams[core.currentPlayer].formation!.numberOfDefenders &&
            (selectedDefenders.length +
                    teams[core.currentPlayer].midfielders.length +
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
          Image(image: AssetImage('images/defender_icon.webp'), width: 50),
          const SizedBox(height: 20),
          const Text(
            'SELECT DEFENDERS',
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
              children: List.generate(allDefenders.length, (index) {
                return GestureDetector(
                  onTap:
                      isSelectable(index)
                          ? () {
                            setState(() {
                              // if already selected
                              if (selectedDefenders.contains(index)) {
                                // remove defender
                                selectedDefenders.remove(index);
                              } else {
                                // add defender
                                selectedDefenders.add(index);
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
                            selectedDefenders.contains(index)
                                ? Border.all(color: Colors.yellow, width: 2.5)
                                : null,
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      ),
                      child: Image.asset(
                        'images/players/${(allDefenders[index].index < 9) ? (allDefenders[index].index + 1).toString().padLeft(2, '0') : allDefenders[index].index + 1}.webp',
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
                  for (var index in selectedDefenders) {
                    Player player = allDefenders[index];
                    teams[core.currentPlayer].addPlayer(player, Position.defender);
                    core.selectedDefenders.add(player);
                  }
                  logger.d('selectedDefenders.length: ${selectedDefenders.length}');
                  logger.d('number of midfielders: ${teams[core.currentPlayer].midfielders.length}');
                  logger.d('number of forwards: ${teams[core.currentPlayer].forwards.length}');

                  if (core.inReview && !core.inManagerReset) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushNamed(context, midfieldersSelectPage).then((_) {
                      debugPrint("Returned from midfielders select page, popping to root");
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
