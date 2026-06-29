import '../name_tag.dart';
import 'package:flutter/material.dart';
import '../background_container.dart';
import '../tac_card.dart';
import '../core.dart';
import '../team.dart';
import '../best_eleven_button.dart';
import 'manager_playing_with_tiles_dialog.dart';
import '../routes.dart';
import '../more_cards_of_color_than_any_other_player.dart';

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
    if (core.inReview) {
      reset();
    }
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
    return (core.selectedTacCards.contains(card) && !selectedCards.contains(card));
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
    return backgroundContainer(context, AssetImage('images/background.webp'), content(context));
  }

  Widget content(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          nameTag(teams[core.currentPlayer].gamePlayer),
          Image(image: AssetImage('images/tactical_icon.webp'), width: 50),
          const SizedBox(height: 20),
          const Text('TACTICAL CARDS', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, fontStyle: FontStyle.italic)),
          Align(alignment: Alignment.topLeft, child: Text('Tap to select or deselect...', style: TextStyle(color: Colors.white, fontSize: 16.0))),
          Expanded(
            child: ListView.builder(
              itemCount: allTacCards.length,
              itemBuilder: (context, index) {
                return AnimatedOpacity(
                  opacity: previouslySelected(allTacCards[index]) ? 0.4 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Card(
                    shape:
                        (isSelectable(allTacCards[index]) || previouslySelected(allTacCards[index]))
                            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))
                            : RoundedRectangleBorder(side: const BorderSide(color: Colors.yellow, width: 2.0), borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.black.withValues(alpha: 0.5),
                    child: ListTile(
                      title: Text(allTacCards[index].name, style: const TextStyle(fontSize: 16, color: Colors.white), overflow: TextOverflow.ellipsis),
                      onTap: () {
                        setState(() {
                          if (isSelectable(allTacCards[index])) {
                            selectedCards.add(allTacCards[index]);
                          } else if (selectedCards.contains(allTacCards[index])) {
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
              BestElevenButton(
                buttonText: 'BACK',
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous page
                },
              ),
              // Next button to go to the next scoring category
              BestElevenButton(
                buttonText: 'NEXT',
                onPressed: () async {
                  for (var card in selectedCards) {
                    if (core.numPlayers == 1 && !core.playingSolo && card.bonusStipulation is MoreCardsOfColorThanAnyOtherPlayerColor) {
                      final String bonusColor = '${(card.bonusStipulation as MoreCardsOfColorThanAnyOtherPlayerColor).color}'.replaceAll("Color.", '');
                      final bool? hasMore = await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder:
                            (BuildContext context) => AlertDialog(
                              actionsAlignment: MainAxisAlignment.center,
                              content: Text(
                                'Do you have more $bonusColor cards than any other player? If you do, click YES, otherwise click NO',
                                style: TextStyle(
                                  fontSize: 18.0, // <-- Adjust content size here
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text(
                                    'YES',
                                    style: TextStyle(
                                      fontSize: 18.0, // <-- Adjust content size here
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text(
                                    'NO',
                                    style: TextStyle(
                                      fontSize: 18.0, // <-- Adjust content size here
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      );
                      if (hasMore == true) {
                        teams[core.currentPlayer].moreColor[(card.bonusStipulation as MoreCardsOfColorThanAnyOtherPlayerColor).color] = true;
                        // teams[core.currentPlayer].tacCards.add(card);
                        // core.selectedTacCards.add(card);
                      }
                    }
                    teams[core.currentPlayer].tacCards.add(card);
                    core.selectedTacCards.add(card);
                  }

                  if (core.inReview) {
                    if (context.mounted) Navigator.pop(context);
                  } else {
                    if (core.currentPlayer == 0) {
                      if (context.mounted) {
                        final String? result = await showPlayingWithManagerTilesDialog(context);
                        if (result != null) {
                          if (context.mounted) {
                            Navigator.pushNamed(context, result).then((_) {
                              debugPrint("Returned from $result page, popping to root");
                              reset();
                            });
                          }
                        }
                      }
                    } else if (core.playingWithManagerTiles) {
                      if (context.mounted) {
                        Navigator.pushNamed(context, managerTileSelectPage).then((_) {
                          debugPrint("Returned from manager tile select page, popping to root");
                          reset();
                        });
                      }
                    } else {
                      if (context.mounted) {
                        Navigator.pushNamed(context, managerSelectPage).then((_) {
                          debugPrint("Returned from manager select page, popping to root");
                          reset();
                        });
                      }
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
