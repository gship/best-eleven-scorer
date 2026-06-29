import 'package:flutter/material.dart';
import '../best_eleven_button.dart';
import '../background_container.dart';
import '../routes.dart';
import '../core.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return backgroundContainer(
      context,
      AssetImage('images/home.webp'),
      content(context),
    );
  }

  Widget content(BuildContext context) {
    void processPressed(int numPlayers) {
      core.numPlayers = numPlayers;

      Navigator.pushNamed(context, nameEntryPage).then((_) {
        debugPrint("Returned from name entry page, popping to root");
        core.numPlayers = 0;
      });
    }

    Padding numPlayersPaddedButton(int numberOfPlayers) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          child: ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              fixedSize: const WidgetStatePropertyAll(Size(200, 80)),
              backgroundColor: WidgetStateProperty.all(Colors.black),
              foregroundColor: WidgetStateProperty.all(Colors.white),
              overlayColor: WidgetStatePropertyAll<Color>(Colors.pink),
            ),
            onPressed: () => processPressed(numberOfPlayers),
            child: Text(
              '$numberOfPlayers Players',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w100),
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
              child: Image(image: AssetImage('images/best_xi_logo.webp')),
            ),
          ),
          numPlayersPaddedButton(2),
          numPlayersPaddedButton(3),
          numPlayersPaddedButton(4),
          SizedBox(height: 20),
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
