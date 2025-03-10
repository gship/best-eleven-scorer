import 'package:best_xi_scorer/name_tag.dart';
import 'package:flutter/material.dart';
import '../core.dart';
import '../main_contain.dart';
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
  int? selectedKeeper; // Holds the selected keeper index

  bool isSelectable(int index) {
    return ((selectedKeeper == null &&
            !core.selectedKeepers.contains(allKeepers[index])) ||
        selectedKeeper == index);
  }

  void reset() {
    // Initialize the selected keeper from teams
    selectedKeeper = teams[core.currentPlayer].keeper?.index;
    core.selectedKeepers.remove(teams[core.currentPlayer].keeper);
    teams[core.currentPlayer].keeper?.playingPosition = null;
    teams[core.currentPlayer].keeper = null;
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

  Widget content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          nameTag(teams[core.currentPlayer].gamePlayer),
          //const SizedBox(height: 20),
          Image(image: AssetImage('images/keeper_icon.png'), width: 50),
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
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              //shrinkWrap: true,
              children: List.generate(allKeepers.length, (index) {
                return GestureDetector(
                  onTap:
                      isSelectable(index)
                          ? () {
                            setState(() {
                              if (selectedKeeper == index) {
                                selectedKeeper =
                                    null; // Deselect if already selected
                              } else {
                                selectedKeeper = index; // Select a new keeper
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
                            'images/keepers/${allKeepers[index].name.replaceAll(' ', '_')}.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                        border:
                            (selectedKeeper == index)
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
                onPressed:
                    selectedKeeper == null
                        ? null // Disable button if no keeper is selected
                        : () {
                          teams[core.currentPlayer].addPlayer(
                            allKeepers[selectedKeeper!],
                            Position.keeper,
                          );
                          core.selectedKeepers.add(allKeepers[selectedKeeper!]);
                          Navigator.pushNamed(
                            context,
                            Routes.defendersSelectPage,
                          ).then((_) {
                            debugPrint('I\'ve been popped keeper page');
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
