import 'package:flutter/material.dart';
import '../core.dart';
import '../name_tag.dart';
import '../main_contain.dart';
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
  }

  void reset() {
    // Initialize the selected forward list from teams
    selectedForwards.clear();
    for (var forward in teams[core.currentPlayer].forwards) {
      selectedForwards.add(forward.forwardsIndex);
      forward.playingPosition = null;
    }
    // Clear the selected forward from teams
    teams[core.currentPlayer].forwards.clear();
    // Clear the selected forward from core
    core.selectedForwards.clear();
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
    Player player = allForwards[index];
    if (index < 20) {}
    bool retVal =
        (((selectedForwards.length <
                        teams[core.currentPlayer].manager!.numberOfForwards &&
                    ((teams[core.currentPlayer].defenders.length +
                            teams[core.currentPlayer].midfielders.length +
                            selectedForwards.length) <
                        10)) ||
                selectedForwards.contains(index)) &&
            !core.selectedDefenders.contains(player) &&
            !core.selectedMidfielders.contains(player) &&
            !core.selectedForwards.contains(player) &&
            !core.playersInHand.contains(player));

    return retVal;
  }

  Widget content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          nameTag(teams[core.currentPlayer].gamePlayer),
          Image(image: AssetImage('images/forward_icon.png'), width: 50),
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
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: List.generate(allForwards.length, (index) {
                return GestureDetector(
                  onTap:
                      isSelectable(index)
                          ? () {
                            setState(() {
                              if (selectedForwards.contains(index)) {
                                selectedForwards.remove(
                                  index,
                                ); // deselect if already selected
                              } else {
                                selectedForwards.add(index); // select forward
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
                        'images/players/${(allForwards[index].index < 9) ? (allForwards[index].index + 1).toString().padLeft(2, '0') : allForwards[index].index + 1}.png',
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
                  for (var temp in selectedForwards) {
                    Player player = allForwards[temp];
                    teams[core.currentPlayer].addPlayer(
                      player,
                      Position.forward,
                    );
                    core.selectedForwards.add(player);
                  }

                  if (teams[core.currentPlayer].needPlayersInHand()) {
                    Navigator.pushNamed(context, Routes.playersInHandPage).then(
                      (_) {
                        debugPrint('I\'ve been popped forwards page');
                        reset();
                      },
                    );
                  } else if (core.currentPlayer < (core.numPlayers - 1)) {
                    // more players
                    ++core.currentPlayer;
                    Navigator.pushNamed(context, Routes.moneyEntryPage).then((
                      _,
                    ) {
                      debugPrint('I\'ve been popped forwards page');
                      reset();
                    });
                  } else {
                    // last or only player
                    if (teams[core.currentPlayer].needPlayersInHand()) {
                      Navigator.pushNamed(
                        context,
                        Routes.playersInHandPage,
                      ).then((_) {
                        debugPrint('I\'ve been popped forwards page');
                        reset();
                      });
                    } else {
                      Navigator.pushNamed(context, Routes.scorePage).then((_) {
                        debugPrint('I\'ve been popped forwards page');
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
