import 'package:best_xi_scorer/name_tag.dart';
import 'package:flutter/material.dart';
import '../main_contain.dart';
import '../tac_card.dart';
import '../core.dart';
import '../team.dart';
import '../routes.dart';
import '../best_eleven_button.dart';

class TacCardPage extends StatefulWidget {
  const TacCardPage({super.key});

  @override
  State<TacCardPage> createState() => _TacCardPageState();
}

class _TacCardPageState extends State<TacCardPage> {
  List<TacCard> selectedCards = []; // Holds selected cards

  @override
  void initState() {
    super.initState();
  }

  void reset() {
    selectedCards = [];
    for (var card in teams[core.currentPlayer].tacCards) {
      selectedCards.add(card);
      core.selectedTacCards.remove(card);
    }
    teams[core.currentPlayer].tacCards.clear();
  }

  bool previouslySelected(TacCard card) {
    return (core.selectedTacCards.contains(card) &&
        !selectedCards.contains(card));
  }

  bool isSelectable(TacCard card) {
    return (!previouslySelected(card) && !selectedCards.contains(card));
  }

  Color backgroundColor(int index) {
    return (isSelectable(allTacCards[index])
        ? Colors.white
        : selectedCards.contains(allTacCards[index])
        ? Colors.yellow
        : Colors.grey);
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
          Image(image: AssetImage('images/tactical_icon.png'), width: 50),
          const SizedBox(height: 20),
          const Text(
            'TACTICAL CARDS',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Tap to select or deselect...',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: allTacCards.length,
              itemBuilder: (context, index) {
                return AnimatedOpacity(
                  opacity: previouslySelected(allTacCards[index]) ? 0.4 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Card(
                    shape:
                        (isSelectable(allTacCards[index]) ||
                                previouslySelected(allTacCards[index]))
                            ? RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )
                            : RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.yellow,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                    color: Colors.black.withValues(alpha: 0.5),
                    child: ListTile(
                      title: Text(
                        allTacCards[index].name,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        debugPrint('onTap - ${allTacCards[index].name}');
                        setState(() {
                          if (isSelectable(allTacCards[index])) {
                            selectedCards.add(allTacCards[index]);
                          } else if (selectedCards.contains(
                            allTacCards[index],
                          )) {
                            selectedCards.remove(allTacCards[index]);
                          }
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Buttons at the bottom
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Back button to go back to the Money page
              BestElevenButton(
                buttonText: 'BACK',
                onPressed: () {
                  Navigator.pop(
                    context,
                  ); // Assuming you want to go back to the previous page
                },
              ),
              // Next button to go to the next scoring category
              BestElevenButton(
                buttonText: 'NEXT',
                onPressed: () {
                  for (var card in selectedCards) {
                    teams[core.currentPlayer].tacCards.add(card);
                    core.selectedTacCards.add(card);
                  }
                  Navigator.pushNamed(context, Routes.managerSelectPage).then((
                    _,
                  ) {
                    debugPrint('I\'ve been popped tac card page');
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
