import 'package:flutter/material.dart';
import '../main_contain.dart';
import '../routes.dart';
import '../core.dart';
import '../home_page_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return mainContain(
      context,
      AssetImage('images/home.png'),
      content(context),
      true,
      false,
    );
  }

  Widget content(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    debugPrint('media size = ${size.width} , ${size.height}');

    return Center(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 30),
            child: SizedBox(
              height: 100,
              child: Image(image: AssetImage('images/best_xi_logo.png')),
            ),
          ),
          HomePageButton(
            leftRight: 50,
            topBottom: 17,
            buttonText: 'Score 1 Player',
            onPressed: () {
              core.numPlayers = 1;

              Navigator.pushNamed(context, Routes.nameEntryPage).then((_) {
                debugPrint('I\'ve been popped home page');
                core.numPlayers = 0;
              });
            },
          ),
          HomePageButton(
            leftRight: 40,
            topBottom: 17,
            buttonText: 'Score All Players',
            onPressed: () {
              Navigator.pushNamed(context, Routes.startPage).then((_) {
                debugPrint('I\'ve been popped home page');
              });
            },
          ),
          HomePageButton(
            leftRight: 20,
            topBottom: 17,
            buttonText: 'View Saved Games',
            onPressed: () {
              Navigator.pushNamed(context, Routes.savedGamesPage).then((_) {
                debugPrint('I\'ve been popped home page');
              });
            },
          ),
          HomePageButton(
            leftRight: 30,
            topBottom: 17,
            buttonText: 'View High Scores',
            onPressed: () {
              Navigator.pushNamed(context, Routes.highScoresPage).then((_) {
                debugPrint('I\'ve been popped home page');
              });
            },
          ),
        ],
      ),
    );
  }
}
