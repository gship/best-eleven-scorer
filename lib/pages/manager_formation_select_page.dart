import '../name_tag.dart';
import 'package:flutter/material.dart';
import '../core.dart';
import '../background_container.dart';
import '../team.dart';
import '../best_eleven_button.dart';
import '../routes.dart';
import '../manager.dart';

class ManagerFormationSelectPage extends StatefulWidget {
  const ManagerFormationSelectPage({super.key});

  @override
  State<ManagerFormationSelectPage> createState() =>
      _ManagerFormationSelectPageState();
}

class _ManagerFormationSelectPageState
    extends State<ManagerFormationSelectPage> {
  int? selectedFormation; // Holds the selected formation index

  @override
  void initState() {
    super.initState();
    if (core.inReview) {
      reset();
    }
  }

  bool isSelectable(int index) {
    return ((selectedFormation == null &&
            !core.selectedFormations.contains(allFormations[index])) ||
        selectedFormation == index);
  }

  void reset() {
    // Initialize the selected manager from teams
    selectedFormation = teams[core.currentPlayer].formation?.tileIndex;
    core.selectedFormations.remove(teams[core.currentPlayer].formation);
    teams[core.currentPlayer].formation = null;
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
          Image(image: AssetImage('images/manager_icon.webp'), width: 50),
          const SizedBox(height: 20),
          const Text(
            'SELECT MANAGER FORMATION',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
          Expanded(
            child: GridView.count(
              childAspectRatio: 0.625,
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: List.generate(allFormationsForTiles.length, (index) {
                return GestureDetector(
                  onTap:
                      isSelectable(index)
                          ? () {
                            setState(() {
                              // if already selected
                              if (selectedFormation == index) {
                                // clear selected formation
                                selectedFormation = null;
                              } else {
                                // save selected formation
                                selectedFormation = index;
                              }
                            });
                          }
                          : null,
                  child: AnimatedOpacity(
                    opacity: isSelectable(index) ? 1.0 : 0.4,
                    // Dim other images
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'images/managers/${allManagers[allFormationsForTiles[index].index].name.replaceAll(' ', '_')}.webp',
                          ),
                          fit: BoxFit.cover,
                        ),
                        border:
                            (selectedFormation == index)
                                ? Border.all(color: Colors.yellow, width: 2.5)
                                : null,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                  //),
                );
              }),
            ),
          ),

          SizedBox(height: 20),

          // Buttons at the bottom
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Back button to go back to the tac card page
              BestElevenButton(
                buttonText: 'BACK',
                onPressed:
                    core.inReview
                        ? null // in review don't go back
                        : () {
                          Navigator.popUntil(
                            context,
                            ModalRoute.withName(tacCardPage),
                          );
                        },
              ),
              // Next button to go to the keeeper select page
              BestElevenButton(
                buttonText: 'NEXT',
                onPressed: () {
                  if (selectedFormation != null) {
                    teams[core.currentPlayer].formation =
                        allFormationsForTiles[selectedFormation!];
                    debugPrint(
                      "Selected formation: ${teams[core.currentPlayer].formation}",
                    );
                    core.selectedFormations.add(
                      allFormationsForTiles[selectedFormation!],
                    );
                    core.inReview = false;
                    Navigator.pushNamed(context, keeperSelectPage).then((
                      _,
                    ) {
                      debugPrint(
                        "Returned from keeper select page, popping to root",
                      );
                      reset();
                    });
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
