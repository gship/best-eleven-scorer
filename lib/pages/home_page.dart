import 'package:flutter/material.dart';
import 'dialogs.dart';
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

    // If not seen, show the dialog
    if (!seen) {
      BuildContext context = this.context;
      debugPrint('Want to show home dialog because it has not been seen yet.');
      if (context.mounted) {
        debugPrint('Showing home dialog.');
        showOkDialog(context, 'Bonus Games and More!', "Click on the three dots in the very top right for bonus games.\nScroll down on any page to see all buttons.");
        // Set the flag in shared preferences so it doesn't show next time
        await prefs.setBool('seen_home_dialog', true);
      }
    }
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
                        () => showOkDialog(
                          context,
                          'Best Eleven Scorer App Team',
                          'App development: Glen Shipley\nArtwork: Cumanche, Dan Evans, David Flores, Alexandra Francis, Conner Gillette, Victor Bizar Gomez, Chester Holme, Dan Leydon, and Matthew Shipley',
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
