import 'package:best_xi_scorer/name_tag.dart';
import 'package:flutter/material.dart';
import '../core.dart';
import '../main_contain.dart';
import '../team.dart';
import '../best_eleven_button.dart';
import '../routes.dart';
import '../manager.dart';

class ManagerSelectPage extends StatefulWidget {
  const ManagerSelectPage({super.key});

  @override
  State<ManagerSelectPage> createState() => _ManagerSelectPageState();
}

class _ManagerSelectPageState extends State<ManagerSelectPage> {
  int? selectedManager; // Holds the selected manager image

  bool isSelectable(int index) {
    return ((selectedManager == null || selectedManager == index) &&
        !core.selectedManagers.contains(allManagers[index]));
  }

  void reset() {
    // Initialize the selected manager from teams
    selectedManager = teams[core.currentPlayer].manager?.index;
    core.selectedManagers.remove(teams[core.currentPlayer].manager);
    teams[core.currentPlayer].manager = null;
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
          Image(image: AssetImage('images/manager_icon.png'), width: 50),
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
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: List.generate(allManagers.length, (index) {
                return GestureDetector(
                  onTap:
                      isSelectable(index)
                          ? () {
                            setState(() {
                              if (selectedManager == index) {
                                // Deselect if already selected
                                selectedManager = null;
                              } else {
                                // Select as manager
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
                            'images/managers/${allManagers[index].name.replaceAll(' ', '_')}.png',
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
              // Back button to go back to the Money page
              BestElevenButton(
                buttonText: 'BACK',
                onPressed:
                    () =>
                        Navigator.pop(context), // Go back to the previous page
              ),
              // Next button to go to the next scoring category
              BestElevenButton(
                buttonText: 'NEXT',
                onPressed:
                    selectedManager == null
                        ? null // Disable button if no manager is selected
                        : () {
                          teams[core.currentPlayer].manager =
                              allManagers[selectedManager!];
                          core.selectedManagers.add(
                            allManagers[selectedManager!],
                          );
                          Navigator.pushNamed(
                            context,
                            Routes.keeperSelectPage,
                          ).then((_) {
                            debugPrint('I\'ve been popped manager page');
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
