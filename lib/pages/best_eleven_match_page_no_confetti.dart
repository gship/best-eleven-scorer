import 'package:flutter/material.dart';
import '../background_container.dart';
import '../best_eleven_button.dart';
import '../player.dart';
import 'dart:math';

class BestElevenMatchPage extends StatefulWidget {
  const BestElevenMatchPage({super.key});

  @override
  State<BestElevenMatchPage> createState() => _BestElevenMatchPageState();
}

class _BestElevenMatchPageState extends State<BestElevenMatchPage> {
  List<int> matchedPlayers = List.empty(
    growable: true,
  ); // Holds the selected defenders indices
  List<Player> playerPool = List.empty(
    growable: true,
  ); // Holds the possible defenders
  int selectedIndex = -1;
  int selectedPlayerIndex = -1;
  int matchCount = 0;
  int otherIndex = -1;
  int moves = 0;

  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    moves = 0;
    selectedIndex = -1;
    otherIndex = -1;
    selectedPlayerIndex = -1;
    matchedPlayers.clear();
    playerPool.clear();
    var random = Random.secure();
    for (int i = 0; i < 8; ++i) {
      var intValue = random.nextInt(101);
      debugPrint('intValue: $intValue');
      playerPool.add(allPlayers[intValue]);
      playerPool.add(allPlayers[intValue]);
    }
    playerPool.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return backgroundContainer(
      context,
      AssetImage('images/background.webp'),
      content(context),
    );
  }

  bool isDisplayable(int index) {
    bool retVal = false;
    retVal = !matchedPlayers.contains(allPlayers[index].index);
    debugPrint('isDisplayable: $retVal');
    return retVal;
  }

  bool isSelected(int index) {
    bool retVal = false;
    retVal = (index == selectedIndex || index == otherIndex);
    debugPrint('isSelected: $retVal');
    return retVal;
  }

  Widget content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Image(image: AssetImage('images/best_xi_logo.webp'), height: 100),
          //const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: List.generate(playerPool.length, (index) {
                return GestureDetector(
                  onTap: () {
                    if (selectedIndex == -1) {
                      // first selection
                      setState(() {
                        selectedIndex = index;
                        selectedPlayerIndex = playerPool[index].index;
                        moves++;
                      });
                    } else if (selectedIndex != index) {
                      if (selectedPlayerIndex == playerPool[index].index) {
                        debugPrint('match found');
                        // remove the matched cards
                        setState(() {
                          otherIndex = index;
                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              matchedPlayers.add(selectedIndex);
                              matchedPlayers.add(index);
                              matchCount++;
                              selectedIndex = -1;
                              otherIndex = -1;
                              selectedPlayerIndex = -1;
                              moves++;
                            });
                          });
                        });
                      } else {
                        // not a match, reset indices
                        setState(() {
                          otherIndex = index;
                          Future.delayed(Duration(seconds: 1), () {
                            setState(() {
                              otherIndex = -1;
                              selectedIndex = -1;
                              selectedPlayerIndex = -1;
                              moves++;
                            });
                          });
                        });
                      }
                    }
                  },
                  child:
                      isDisplayable(index)
                          ? AnimatedOpacity(
                            opacity: 1.0,
                            duration: Duration(milliseconds: 300),
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    isSelected(index)
                                        ? Border.all(
                                          color: Colors.yellow,
                                          width: 2.5,
                                        )
                                        : Border.all(
                                          color: Colors.black,
                                          width: 2.5,
                                        ),
                                borderRadius: BorderRadius.all(
                                  isSelected(index)
                                      ? Radius.circular(14.0)
                                      : Radius.circular(0.0),
                                ),
                              ),
                              child:
                                  isSelected(index)
                                      ? Image.asset(
                                        'images/players/${(playerPool[index].index < 9) ? (playerPool[index].index + 1).toString().padLeft(2, '0') : playerPool[index].index + 1}.webp',
                                      )
                                      : Image.asset('images/1024x1024.webp'),
                            ),
                          )
                          : null,
                );
              }),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Moves: $moves',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          SizedBox(height: 20),
          // Buttons at the bottom
          BestElevenButton(
            buttonText: 'Play Again',
            onPressed: () {
              setState(() {
                reset();
              });
            },
          ),
          SizedBox(height: 20),
          BestElevenButton(
            buttonText: 'BACK',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
