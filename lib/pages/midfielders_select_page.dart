import 'package:best_xi_scorer/name_tag.dart';
import 'package:flutter/material.dart';
import '../core.dart';
import '../main_contain.dart';
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
  }

  void reset() {
    // Initialize the selected midfielder list from teams
    selectedMidfielders.clear();
    for (var midfielder in teams[core.currentPlayer].midfielders) {
      selectedMidfielders.add(midfielder.midfieldersIndex);
      midfielder.playingPosition = null;
    }
    // Clear the selected midfielder from teams
    teams[core.currentPlayer].midfielders.clear();
    // Clear the selected midfielder from core
    core.selectedMidfielders.clear();
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
    Player player = allMidfielders[index];
    return (((selectedMidfielders.length <
                    teams[core.currentPlayer].manager!.numberOfMidfielders &&
                ((teams[core.currentPlayer].defenders.length +
                        selectedMidfielders.length +
                        teams[core.currentPlayer].forwards.length) <
                    10)) ||
            selectedMidfielders.contains(index)) &&
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
          Image(image: AssetImage('images/midfielder_icon.png'), width: 50),
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
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              //shrinkWrap: true,
              children: List.generate(allMidfielders.length, (index) {
                return GestureDetector(
                  onTap:
                      isSelectable(index)
                          ? () {
                            setState(() {
                              if (selectedMidfielders.contains(index)) {
                                selectedMidfielders.remove(
                                  index,
                                ); // deselect if already selected
                              } else {
                                selectedMidfielders.add(
                                  index,
                                ); // select midfielder
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
                        'images/players/${(allMidfielders[index].index < 9) ? (allMidfielders[index].index + 1).toString().padLeft(2, '0') : allMidfielders[index].index + 1}.png',
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
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous page
                },
              ),
              // Next button to go to the next scoring category
              BestElevenButton(
                buttonText: 'NEXT',
                onPressed: () {
                  for (var temp in selectedMidfielders) {
                    Player player = allMidfielders[temp];
                    teams[core.currentPlayer].addPlayer(
                      player,
                      Position.midfielder,
                    );
                    core.selectedMidfielders.add(player);
                  }
                  Navigator.pushNamed(context, Routes.forwardsSelectPage).then((
                    _,
                  ) {
                    debugPrint('I\'ve been popped midfielder page');
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
