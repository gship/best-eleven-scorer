import 'package:flutter/material.dart';
import '../new_best_eleven_button.dart';
import '../player.dart';
import 'dart:math';
import 'package:confetti/confetti.dart';

class BestElevenKeeperMatchPage extends StatefulWidget {
  const BestElevenKeeperMatchPage({super.key});

  @override
  State<BestElevenKeeperMatchPage> createState() =>
      _BestElevenKeeperMatchPageState();
}

class _BestElevenKeeperMatchPageState extends State<BestElevenKeeperMatchPage> {
  List<int> matchedKeepers = List.empty(
    growable: true,
  ); // Holds the matched player indices
  List<Player> keeperPool = List.empty(
    growable: true,
  ); // Holds the possible players
  List<int> keeperMap = List.empty(
    growable: true,
  ); // Holds the possible player indices
  int selectedIndex = -1;
  int selectedKeeperIndex = -1;
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
    matchCount = 0;
    selectedIndex = -1;
    otherIndex = -1;
    selectedKeeperIndex = -1;
    matchedKeepers.clear();
    keeperPool.clear();
    keeperMap.clear();
    var random = Random.secure();
    var count = 0;
    while (count < 8) {
      var intValue = random.nextInt(allKeepers.length);
      if (!keeperMap.contains(intValue)) {
        keeperMap.add(intValue);
        keeperPool.add(allKeepers[intValue]);
        keeperPool.add(allKeepers[intValue]);
        count++;
      }
    }
    keeperPool.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    final ConfettiController confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    // check if any score is a high score
    if (matchCount == 8) {
      confettiController.play();
    }

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        // Image set to background of the body
        image: DecorationImage(
          image: AssetImage('images/background.webp'),
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420, maxHeight: 1000),
          child: content(context, confettiController, matchCount == 8),
        ),
      ),
    );
  }

  bool isDisplayable(int index) {
    bool retVal = false;
    retVal = !matchedKeepers.contains(allPlayers[index].index);
    return retVal;
  }

  bool isSelected(int index) {
    bool retVal = false;
    retVal = (index == selectedIndex || index == otherIndex);
    return retVal;
  }

  Widget content(
    BuildContext context,
    ConfettiController confettiController,
    bool showConfetti,
  ) {
    List<Widget> stackList = [];
    stackList.add(
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10.0, 20, 0),
              child: Image(
                image: AssetImage('images/best_xi_logo.webp'),
                height: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20.0, 10, 20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: List.generate(keeperPool.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      debugPrint('tapped index $index');
                      // if not already cleared from board
                      if (matchedKeepers.contains(index)) {
                        debugPrint('already matched');
                      } else {
                        debugPrint('not already matched');
                        // if first of possible pair
                        if (selectedIndex == -1) {
                          setState(() {
                            selectedIndex = index;
                            selectedKeeperIndex = keeperPool[index].index;
                          });
                          // if not the already selected card
                        } else if (selectedIndex != index) {
                          if (selectedKeeperIndex == keeperPool[index].index) {
                            debugPrint('match found');
                            // remove the matched cards
                            setState(() {
                              otherIndex = index;
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {
                                  matchedKeepers.add(selectedIndex);
                                  matchedKeepers.add(index);
                                  matchCount++;
                                  selectedIndex = -1;
                                  otherIndex = -1;
                                  selectedKeeperIndex = -1;
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
                                  selectedKeeperIndex = -1;
                                  moves++;
                                });
                              });
                            });
                          }
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
                                        ? Radius.circular(10.0)
                                        : Radius.circular(0.0),
                                  ),
                                ),
                                child:
                                    isSelected(index)
                                        ? Image.asset(
                                          'images/keepers/${keeperPool[index].name.replaceAll(' ', '_')}.webp',
                                        )
                                        : Image.asset('images/1024x1024.webp'),
                              ),
                            )
                            : null,
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 20, color: Colors.white),
                child: Text('Moves: $moves'),
              ),
            ),
            // Buttons at the bottom
            NewBestElevenButton(
              buttonText: 'Play Again',
              onPressed: () {
                setState(() {
                  reset();
                });
              },
            ),
            SizedBox(height: 20),
            NewBestElevenButton(
              buttonText: 'BACK',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );

    if (showConfetti) {
      stackList.add(
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            emissionFrequency: 0.04,
            numberOfParticles: 40,
            confettiController: confettiController,
            // don't specify a direction, blast randomly
            blastDirectionality: BlastDirectionality.explosive,
            // start again as soon as the animation is finished
            shouldLoop: false,
            // manually specify the colors to be used
            colors: const [Colors.yellow],
          ),
        ),
      );
    }

    Stack stack = Stack(children: stackList);

    return Padding(padding: const EdgeInsets.all(20.0), child: stack);

    //retList.add(stack);

    //return stack;
  }
}
