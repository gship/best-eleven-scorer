import '../name_tag.dart';
import 'package:flutter/material.dart';
import '../core.dart';
import '../background_container.dart';
import '../team.dart';
import '../best_eleven_button.dart';
import '../routes.dart';
import '../manager.dart';

class ManagerSoloSelectPage extends StatefulWidget {
  const ManagerSoloSelectPage({super.key});

  @override
  State<ManagerSoloSelectPage> createState() => _ManagerSoloSelectPageState();
}

class _ManagerSoloSelectPageState extends State<ManagerSoloSelectPage> {
  int? selectedManager; // Holds the selected manager tile index

  @override
  void initState() {
    super.initState();
    if (core.inReview) {
      reset();
    }
    core.playingWithManagerTiles = false;
  }

  bool isSelectable(int index) {
    return ((selectedManager == null &&
            !core.selectedManagers.contains(
              allManagersWithFormations[index],
            )) ||
        selectedManager == index);
  }

  void reset() {
    // Initialize the selected manager from teams
    selectedManager = teams[core.currentPlayer].manager?.index;
    core.selectedManagers.remove(teams[core.currentPlayer].manager);
    core.selectedFormations.remove(teams[core.currentPlayer].formation);
    teams[core.currentPlayer].manager = null;
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
            'SELECT MANAGER',
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
              children: List.generate(allManagersWithFormations.length, (
                index,
              ) {
                return GestureDetector(
                  onTap:
                      isSelectable(index)
                          ? () {
                            setState(() {
                              // if already selected
                              if (selectedManager == index) {
                                // clear selected manager tile
                                selectedManager = null;
                              } else {
                                // save selected manager tile
                                selectedManager = index;
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
                            'images/managers/${allManagersWithFormations[index].name.replaceAll(' ', '_')}.webp',
                          ),
                          fit: BoxFit.cover,
                        ),
                        border:
                            (selectedManager == index)
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
                  if (selectedManager != null) {
                    teams[core.currentPlayer].manager =
                        allManagersWithFormations[selectedManager!];
                    core.selectedManagers.add(
                      allManagersWithFormations[selectedManager!],
                    );
                    teams[core.currentPlayer].formation =
                        allFormations[selectedManager!];
                    core.selectedFormations.add(
                      allFormations[selectedManager!],
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
