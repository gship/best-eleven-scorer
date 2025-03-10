import 'package:flutter/material.dart';
import '../best_eleven_button.dart';
import '../main_contain.dart';
import '../routes.dart';
import '../core.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

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
    void processPressed(int numPlayers) {
      core.numPlayers = numPlayers;

      Navigator.pushNamed(context, Routes.nameEntryPage).then((_) {
        debugPrint('I\'ve been popped start page');
        core.numPlayers = 0;
      });
    }

    final Size size = MediaQuery.sizeOf(context);
    debugPrint('media size = ${size.width} , ${size.height}');

    Padding numPlayersPaddedButton(int playerNum) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          child: ElevatedButton(
            style: ButtonStyle(
              padding:
                  (playerNum > 1)
                      ? WidgetStatePropertyAll(
                        EdgeInsets.fromLTRB(40, 17, 40, 17),
                      )
                      : WidgetStatePropertyAll(
                        EdgeInsets.fromLTRB(46, 17, 46, 17),
                      ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              minimumSize: const WidgetStatePropertyAll(Size(100, 60)),
              backgroundColor: WidgetStateProperty.all(Colors.black),
              foregroundColor: WidgetStateProperty.all(Colors.white),
              overlayColor: WidgetStatePropertyAll<Color>(Colors.pink),
            ),
            onPressed: () => processPressed(playerNum),
            child: Text(
              '$playerNum Player${(playerNum > 1) ? 's' : ''}',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w100),
            ),
          ),
        ),
      );
    }

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
          numPlayersPaddedButton(2),
          numPlayersPaddedButton(3),
          numPlayersPaddedButton(4),
          Align(
            child: BestElevenButton(
              buttonText: 'BACK',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
