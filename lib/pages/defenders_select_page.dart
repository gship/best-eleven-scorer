import 'package:flutter/material.dart';
import '../name_tag.dart';
import '../core.dart';
import '../main_contain.dart';
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
  }

  void reset() {
    // Initialize the selected defender list from teams
    selectedDefenders.clear();
    for (var defender in teams[core.currentPlayer].defenders) {
      selectedDefenders.add(defender.defendersIndex);
      // Reset the playing position of the defender
      defender.playingPosition = null;
      // Remove the selected defender from core
      core.selectedDefenders.remove(defender);
    }
    // Clear the team's defenders
    teams[core.currentPlayer].defenders.clear();
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
    Player player = allDefenders[index];
    return (((selectedDefenders.length <
                    teams[core.currentPlayer].manager!.numberOfDefenders &&
                ((selectedDefenders.length +
                        teams[core.currentPlayer].midfielders.length +
                        teams[core.currentPlayer].forwards.length) <
                    10)) ||
            selectedDefenders.contains(index)) &&
        !core.selectedDefenders.contains(player) &&
        !core.selectedMidfielders.contains(player) &&
        !core.selectedForwards.contains(player) &&
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
          Image(image: AssetImage('images/defender_icon.png'), width: 50),
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
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: List.generate(allDefenders.length, (index) {
                return GestureDetector(
                  onTap:
                      isSelectable(index)
                          ? () {
                            setState(() {
                              if (selectedDefenders.contains(index)) {
                                selectedDefenders.remove(
                                  index,
                                ); // deselect if already selected
                              } else {
                                selectedDefenders.add(index); // select defender
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
                        'images/players/${(allDefenders[index].index < 9) ? (allDefenders[index].index + 1).toString().padLeft(2, '0') : allDefenders[index].index + 1}.png',
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
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous page
                },
              ),
              // Next button to go to the next scoring category
              BestElevenButton(
                buttonText: 'NEXT',
                onPressed: () {
                  for (var temp in selectedDefenders) {
                    Player player = allDefenders[temp];
                    teams[core.currentPlayer].addPlayer(
                      player,
                      Position.defender,
                    );
                    core.selectedDefenders.add(player);
                  }
                  Navigator.pushNamed(
                    context,
                    Routes.midfieldersSelectPage,
                  ).then((_) {
                    debugPrint('I\'ve been popped defenders page');
                    reset();
                  });
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
