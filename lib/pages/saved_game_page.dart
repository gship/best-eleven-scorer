import 'package:flutter/material.dart';
import '../main_contain.dart';
import '../team.dart';
import '../best_eleven_button.dart';
import '../save_game.dart';
import '../saved_game.dart';
import '../manager.dart';
import '../player.dart';
import '../name_tag.dart';
import '../score_pad.dart';

class SavedGamePage extends StatefulWidget {
  const SavedGamePage({super.key});

  @override
  State<SavedGamePage> createState() => _SavedGamePageState();
}

class _SavedGamePageState extends State<SavedGamePage> {
  getSavedGame(int savedGameId) async {
    await saveGame.getSavedGame(savedGameId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    savedTeams.clear();
    getSavedGame(savedGameId);
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

  Widget single(String icon, String image) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            SizedBox(
              height: 30,
              width: 30,
              child: Image(image: AssetImage(icon), fit: BoxFit.contain),
            ),
            SizedBox(width: 10),
            SizedBox(
              height: 70,
              width: 70,
              child: Image(image: AssetImage(image), fit: BoxFit.contain),
            ),
          ],
        ),
      ],
    );
  }

  Widget players(String icon, List<Player> players) {
    if (players.isEmpty) return SizedBox(height: 0);
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            SizedBox(
              height: 30,
              width: 30,
              child: Image(image: AssetImage(icon), fit: BoxFit.contain),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Wrap(
                spacing: 8.0,
                children:
                    players.map((player) {
                      return SizedBox(
                        width: 70,
                        height: 70,
                        child: Image.asset(
                          'images/players/${(allPlayers[player.index].index < 9) ? (allPlayers[player.index].index + 1).toString().padLeft(2, '0') : allPlayers[player.index].index + 1}.png',
                        ),
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget content(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: List.generate(savedTeams.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 10),
                              nameTag(savedTeams[index].gamePlayer),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 10),
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: Image(
                                  image: AssetImage(
                                    'images/money_icon_big.png',
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(width: 10),
                              Card(
                                color: Colors.black.withValues(alpha: 0.5),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    savedTeams[index].money.toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 10),
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: Image(
                                  image: AssetImage('images/tactical_icon.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Wrap(
                                  children:
                                      savedTeams[index].tacCards.map((tacCard) {
                                        return Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Card(
                                            color: Colors.black.withValues(
                                              alpha: 0.5,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Text(
                                                tacCard.name,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                            ],
                          ),
                          single(
                            'images/manager_icon.png',
                            'images/managers/${allManagers[savedTeams[index].manager!.index].name.replaceAll(' ', '_')}.png',
                          ),
                          single(
                            'images/keeper_icon.png',
                            'images/keepers/${allKeepers[savedTeams[index].keeper!.index].name.replaceAll(' ', '_')}.png',
                          ),
                          players(
                            'images/defender_icon.png',
                            savedTeams[index].defenders,
                          ),
                          players(
                            'images/midfielder_icon.png',
                            savedTeams[index].midfielders,
                          ),
                          players(
                            'images/forward_icon.png',
                            savedTeams[index].forwards,
                          ),
                          players(
                            'images/blank_position_icon.png',
                            savedTeams[index].hand,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage('images/best_xi_logo.png'), height: 60),
                const SizedBox(height: 15),
                scorePad(savedTeams, MainAxisAlignment.center),
              ],
            ),
            const SizedBox(height: 20),
            BestElevenButton(
              buttonText: 'BACK',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
