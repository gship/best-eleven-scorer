import '../name_tag.dart';
import 'package:flutter/material.dart';
import '../core.dart';
import '../background_container.dart';
import '../team.dart';
import '../best_eleven_button.dart';
import '../routes.dart';
import '../player.dart';
import '../position.dart';

class KeeperSelectPage extends StatefulWidget {
  const KeeperSelectPage({super.key});

  @override
  State<KeeperSelectPage> createState() => _KeeperSelectPageState();
}

class _KeeperSelectPageState extends State<KeeperSelectPage> {
  int selectedKeeperIndex = -1; // Holds the selected keeper index

  @override
  void initState() {
    super.initState();
    if (core.inReview) {
      reset();
    }
  }

  bool isSelectable(int index) {
    return ((selectedKeeperIndex == -1 &&
            !core.selectedKeepers.contains(allKeepers[index])) ||
        selectedKeeperIndex == index);
  }

  void reset() {
    // Initialize the selected keeper from teams
    selectedKeeperIndex = teams[core.currentPlayer].keeperIndex;
    core.selectedKeepers.remove(teams[core.currentPlayer].keeper);
    allPlayerStats[teams[core.currentPlayer].keeper!.allPlayersIndex]
        .playingPosition = null;
    teams[core.currentPlayer].keeper = null;
    teams[core.currentPlayer].keeperIndex = -1;
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
          //const SizedBox(height: 20),
          Image(image: AssetImage('images/keeper_icon.webp'), width: 50),
          const SizedBox(height: 20),
          const Text(
            'SELECT KEEPER',
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
              children: List.generate(allKeepers.length, (index) {
                return GestureDetector(
                  onTap:
                      isSelectable(index)
                          ? () {
                            setState(() {
                              // if already selected
                              if (selectedKeeperIndex == index) {
                                // clear selected keeper
                                selectedKeeperIndex = -1;
                              } else {
                                // save selected keeper
                                selectedKeeperIndex = index;
                              }
                            });
                          }
                          : null,
                  child: AnimatedOpacity(
                    opacity: isSelectable(index) ? 1.0 : 0.4,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'images/keepers/${allKeepers[index].name.replaceAll(' ', '_')}.webp',
                          ),
                          fit: BoxFit.cover,
                        ),
                        border:
                            (selectedKeeperIndex == index)
                                ? Border.all(color: Colors.yellow, width: 2.5)
                                : null,
                        borderRadius: BorderRadius.circular(14),
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
                  if (selectedKeeperIndex != -1) {
                    teams[core.currentPlayer].addPlayer(
                      allKeepers[selectedKeeperIndex],
                      Position.keeper,
                    );
                    core.selectedKeepers.add(allKeepers[selectedKeeperIndex]);

                    if (core.inReview && !core.inManagerReset) {
                      Navigator.pop(context); // Go back to the review page
                    } else {
                      var route = defendersSelectPage;
                      if (core.currentPlayer == 1 && core.playingSolo) {
                        route = automaTeamSelectPage;
                      }
                      Navigator.pushNamed(context, route).then((_) {
                        debugPrint(
                          "Returned from $route page, popping to root",
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
