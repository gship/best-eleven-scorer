import 'package:flutter/material.dart';
import '../background_container.dart';
import '../routes.dart';
import '../core.dart';
import '../home_page_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Schedule the dialog check for after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowDialog();
    });
  }

  Future<void> _checkAndShowDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen_home_dialog') ?? false);

    if (!seen) {
      // If not seen, show the dialog
      _showMyDialog();
      // Set the flag in shared preferences so it doesn't show next time
      await prefs.setBool('seen_home_dialog', true);
    }
  }

  void _showMyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Welcome!",
            style: TextStyle(
              fontSize: 24.0, // <-- Adjust title size here
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Click on the three dots in the very top right for bonus games.\nScroll down on any page to see all buttons.",
            style: TextStyle(
              fontSize: 18.0, // <-- Adjust content size here
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "OK",
                style: TextStyle(
                  fontSize: 18.0, // <-- Adjust content size here
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return backgroundContainer(context, homePageBackgroundImage, content(context));
  }

  Widget content(BuildContext context) {
    return Center(
      child: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MenuAnchor(
                builder: (BuildContext context, MenuController controller, Widget? child) {
                  return IconButton(
                    color: Colors.white,
                    iconSize: 100,
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    icon: const Icon(Icons.more_horiz),
                    tooltip: 'Show menu',
                  );
                },
                menuChildren: <Widget>[
                  MenuItemButton(
                    onPressed:
                        () => showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: const Text(
                                'App development: Glen Shipley\n'
                                'Artwork: Cumanche, Dan Evans, David Flores, Alexandra Francis, Conner Gillette, Victor Bizar Gomez, Chester Holme, Dan Leydon, and Matthew Shipley\n',
                                style: TextStyle(
                                  fontSize: 18.0, // <-- Adjust content size here
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                      fontSize: 18.0, // <-- Adjust content size here
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                    child: Text('About'),
                  ),
                  MenuItemButton(onPressed: () => Navigator.pushNamed(context, bestElevenMatchPage), child: Text('Best Eleven Match')),
                  MenuItemButton(onPressed: () => Navigator.pushNamed(context, bestElevenKeeperMatchPage), child: Text('Best Eleven Keeper Match')),
                ],
              ),
            ],
          ),
          Padding(padding: const EdgeInsets.only(top: 0, bottom: 30), child: SizedBox(height: 100, child: Image(image: AssetImage('images/best_xi_logo.webp')))),
          HomePageButton(
            buttonText: 'Score Solo',
            onPressed: () {
              core.reset();
              core.numPlayers = 1;
              core.playingSolo = true;
              Navigator.pushNamed(context, nameEntryPage).then((_) {
                core.numPlayers = 0;
              });
            },
          ),
          HomePageButton(
            buttonText: 'Score One',
            onPressed: () {
              core.reset();
              core.numPlayers = 1;
              core.playingSolo = false;
              Navigator.pushNamed(context, nameEntryPage).then((_) {});
            },
          ),
          HomePageButton(
            buttonText: 'Score All',
            onPressed: () {
              core.reset();
              core.playingSolo = false;
              Navigator.pushNamed(context, startPage).then((_) {});
            },
          ),
          HomePageButton(
            buttonText: 'View Saved Games',
            onPressed: () {
              Navigator.pushNamed(context, savedGamesPage).then((_) {});
            },
          ),
          HomePageButton(
            buttonText: 'View High Scores',
            onPressed: () {
              Navigator.pushNamed(context, highScoresPage).then((_) {});
            },
          ),
        ],
      ),
    );
  }
}
