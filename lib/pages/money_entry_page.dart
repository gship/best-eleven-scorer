import '../name_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../routes.dart';
import '../team.dart';
import '../core.dart';
import '../best_eleven_button.dart';
import '../background_container.dart';

class MoneyEntryPage extends StatefulWidget {
  const MoneyEntryPage({super.key});

  @override
  State<MoneyEntryPage> createState() => _MoneyEntryPageState();
}

class _MoneyEntryPageState extends State<MoneyEntryPage> {
  late TextEditingController moneyEntryController;

  @override
  void initState() {
    super.initState();
    moneyEntryController = TextEditingController();
    if (core.inReview) {
      moneyEntryController.text = teams[core.currentPlayer].money.toString();
      teams[core.currentPlayer].money = 0;
    }
  }

  @override
  void dispose() {
    moneyEntryController.dispose();
    super.dispose();
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
        children: <Widget>[
          const SizedBox(height: 20),
          nameTag(teams[core.currentPlayer].gamePlayer),
          Image(image: AssetImage('images/money_icon_big.webp'), width: 50),
          const SizedBox(height: 20),
          const Text(
            'MONEY',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            autofocus: true,
            style: const TextStyle(
              fontFamily: 'Providence',
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white),
              labelText: "How much money?",
              fillColor: Colors.black.withValues(alpha: 0.5),
              filled: true,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 2, color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 2, color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(width: 2, color: Colors.white),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(
                  10,
                ), // Adjust radius for desired roundness
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],

            // Only numbers can be entered
            controller: moneyEntryController,
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Back button to go back to the Money page
              BestElevenButton(
                buttonText: 'BACK',
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous page
                },
              ),
              // Next button to go to the next scoring category
              BestElevenButton(
                buttonText: 'NEXT',
                onPressed: () {
                  teams[core.currentPlayer].money = int.parse(
                    moneyEntryController.text,
                  );
                  debugPrint('money set to ${teams[core.currentPlayer].money}');
                  if (core.inReview) {
                    debugPrint('Returning to teams review page');
                    Navigator.pop(context, true);
                  } else {
                    if (core.currentPlayer == 1 && core.playingSolo) {
                      Navigator.pushNamed(
                        context,
                        keeperSelectPage,
                      ).then((_) {
                        debugPrint(
                          "Returned from keeper select page, popping to root",
                        );
                        teams[core.currentPlayer].money = 0;
                      });
                    } else {
                      Navigator.pushNamed(context, tacCardPage).then((
                        _,
                      ) {
                        debugPrint(
                          "Returned from tac card page, popping to root",
                        );
                        teams[core.currentPlayer].money = 0;
                      });
                    }
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
