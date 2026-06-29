import 'package:flutter/material.dart';
import '../background_container.dart';
import '../team.dart';
import '../best_eleven_button.dart';
import '../manager.dart';
import '../player.dart';
import '../name_tag.dart';
import '../routes.dart';
import '../core.dart';
import 'teams_review_dialog.dart';
import 'manager_reset_dialog.dart';

class TeamsReviewPage extends StatefulWidget {
  const TeamsReviewPage({super.key});

  @override
  State<TeamsReviewPage> createState() => _TeamsReviewPageState();
}

class _TeamsReviewPageState extends State<TeamsReviewPage> {
  bool redrawPage = false;
  final List<Widget> _children = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showTeamsReviewDialog(context);
    });
    addChildren();
  }

  @override
  Widget build(BuildContext context) {
    core.inReview = true;
    core.inManagerReset = false;

    if (redrawPage) {
      _children.clear();
      addChildren();
      redrawPage = false;
    }

    return backgroundContainer(
      context,
      const AssetImage('images/background.webp'),
      content(context),
    );
  }

  Widget single(
    BuildContext context,
    String route,
    String icon,
    String image,
    double width,
    double height, [
    bool needToResetTeam = false,
  ]) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () async {
                if (needToResetTeam) {
                  // have to rewind to reset team
                  await showManagerResetDialog(context);
                  core.inManagerReset = true;
                  if (context.mounted) {
                    Navigator.popUntil(context, ModalRoute.withName(route));
                  }
                } else {
                  // just need to update selected
                  Navigator.pushNamed(context, route).then((_) {
                    if (mounted) {
                      setState(() {
                        redrawPage = true;
                      });
                    }
                  });
                }
              },
              child: SizedBox(
                height: 30,
                width: 30,
                child: Image(image: AssetImage(icon), fit: BoxFit.contain),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: height,
              width: width,
              child: Image(image: AssetImage(image), fit: BoxFit.contain),
            ),
          ],
        ),
      ],
    );
  }

  List<Expanded> iconChildList(List<String> icons) {
    List<Expanded> children = [];
    for (String icon in icons) {
      children.add(
        Expanded(
          flex: 1,
          child: Image(image: AssetImage(icon), fit: BoxFit.contain),
        ),
      );
    }

    return children;
  }

  Widget players(
    BuildContext context,
    String route,
    List<Expanded> iconChildList,
    List<Player> players,
  ) {
    if (players.isEmpty) return SizedBox(height: 0);
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, route).then(
                  (_) => setState(() {
                    redrawPage = true;
                  }),
                );
              },
              child: SizedBox(
                height: 30,
                width: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: iconChildList,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 7.0,
                children:
                    players.map((player) {
                      return SizedBox(
                        width: 70,
                        height: 70,
                        child: Image.asset(
                          'images/players/${(allPlayers[player.index].index < 9) ? (allPlayers[player.index].index + 1).toString().padLeft(2, '0') : allPlayers[player.index].index + 1}.webp',
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

  void addChildren() {
    _children.add(const SizedBox(height: 20));
    _children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 10),
          nameTag(teams[core.currentPlayer].gamePlayer),
        ],
      ),
    );
    _children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, moneyEntryPage).then(
                (_) => setState(() {
                  redrawPage = true;
                }),
              );
            },
            child: SizedBox(
              height: 30,
              width: 30,
              child: Image(
                image: AssetImage('images/money_icon_big.webp'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Card(
            color: Colors.black.withValues(alpha: 0.5),

            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                teams[core.currentPlayer].money.toString(),
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
    _children.add(const SizedBox(height: 15));
    if (core.currentPlayer == 1 && core.playingSolo) {
      // this is automa
      // add keeper and players
      _children.add(
        single(
          context,
          keeperSelectPage,
          'images/keeper_icon.webp',
          'images/keepers/${allKeepers[teams[core.currentPlayer].keeper!.index].name.replaceAll(' ', '_')}.webp',
          75.0,
          75.0,
        ),
      );
      List<Player> playersSansKeeper = [];
      for (var player in teams[core.currentPlayer].players) {
        if (!player.isKeeper) {
          playersSansKeeper.add(player);
        }
      }
      _children.add(
        players(
          context,
          automaTeamSelectPage,
          iconChildList([
            'images/defender_icon.webp',
            'images/midfielder_icon.webp',
            'images/forward_icon.webp',
          ]),
          playersSansKeeper,
        ),
      );
    } else {
      _children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, tacCardPage).then(
                  (_) => setState(() {
                    redrawPage = true;
                  }),
                );
              },
              child: SizedBox(
                height: 30,
                width: 30,
                child: Image(
                  image: AssetImage('images/tactical_icon.webp'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Wrap(
                children:
                    teams[core.currentPlayer].tacCards.map((tacCard) {
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Card(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
      );

      if (core.playingWithManagerTiles) {
        _children.add(
          single(
            context,
            managerTileSelectPage,
            'images/manager_icon.webp',
            'images/managers/${allManagers[teams[core.currentPlayer].manager!.index].name.replaceAll(' ', '_')}.webp',
            64.0,
            100.0,
            false,
          ),
        );
        _children.add(
          single(
            context,
            managerFormationSelectPage,
            'images/manager_icon.webp',
            'images/managers/${allManagers[teams[core.currentPlayer].formation!.index].name.replaceAll(' ', '_')}.webp',
            64.0,
            100.0,
            true,
          ),
        );
      } else if (core.playingSolo) {
        _children.add(
          single(
            context,
            managerSoloSelectPage,
            'images/manager_icon.webp',
            'images/managers/${allManagers[teams[core.currentPlayer].manager!.index].name.replaceAll(' ', '_')}.webp',
            64.0,
            100.0,
            true,
          ),
        );
      } else {
        _children.add(
          single(
            context,
            managerSelectPage,
            'images/manager_icon.webp',
            'images/managers/${allManagers[teams[core.currentPlayer].manager!.index].name.replaceAll(' ', '_')}.webp',
            64.0,
            100.0,
            true,
          ),
        );
      }
      _children.add(
        single(
          context,
          keeperSelectPage,
          'images/keeper_icon.webp',
          'images/keepers/${allKeepers[teams[core.currentPlayer].keeper!.index].name.replaceAll(' ', '_')}.webp',
          75.0,
          75.0,
        ),
      );
      _children.add(
        players(
          context,
          defendersSelectPage,
          iconChildList(['images/defender_icon.webp']),
          teams[core.currentPlayer].defenders,
        ),
      );
      _children.add(
        players(
          context,
          midfieldersSelectPage,
          iconChildList(['images/midfielder_icon.webp']),
          teams[core.currentPlayer].midfielders,
        ),
      );
      _children.add(
        players(
          context,
          forwardsSelectPage,
          iconChildList(['images/forward_icon.webp']),
          teams[core.currentPlayer].forwards,
        ),
      );
      _children.add(
        players(
          context,
          playersInHandPage,
          iconChildList(['images/blank_position_icon.webp']),
          teams[core.currentPlayer].hand,
        ),
      );
    }
  }

  Widget content(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(children: _children),
            ),
            const SizedBox(height: 20),
            BestElevenButton(
              buttonText: 'NEXT',
              onPressed: () {
                core.inReview = false;
                if (core.currentPlayer < (core.numPlayers - 1)) {
                  // more players
                  ++core.currentPlayer;
                  Navigator.pushNamed(context, moneyEntryPage).then((_) {
                    --core.currentPlayer;
                    debugPrint(
                      "Returned to review page from money entry page, core.currentPlayer = ${core.currentPlayer}",
                    );
                  });
                } else {
                  if (core.numPlayers == 1 && core.playingSolo) {
                    if (core.currentPlayer == 0) {
                      // single player, go to automa entry page
                      ++core.currentPlayer;
                      Navigator.pushNamed(context, moneyEntryPage).then((
                        _,
                      ) {
                        debugPrint(
                          "Returned to review page from money entry page, popping to root",
                        );
                        --core.currentPlayer;
                        debugPrint(
                          "core.currentPlayer = ${core.currentPlayer}",
                        );
                      });
                    } else {
                      // all entered, go to score page
                      Navigator.pushNamed(context, scorePage).then((_) {
                        debugPrint(
                          "Returned to review page, automa, from score page, popping to root",
                        );
                        debugPrint(
                          "core.currentPlayer = ${core.currentPlayer}",
                        );
                      });
                    }
                  } else {
                    // last player, go to score page
                    Navigator.pushNamed(context, scorePage).then((_) {
                      debugPrint(
                        "Returned to review page, last player, from score page, popping to root",
                      );
                    });
                  }
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
