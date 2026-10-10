import 'package:flutter/material.dart';
import 'next_back_button_test.dart';

Row getNewRow(String font, {bool bold = false, bool google = true}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      // Back button to go back to the Money page
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: NextBackButton(
          buttonText: 'BACK',
          onPressed: () {
            debugPrint('BACK pressed');
          },
          font: font,
          bold: bold,
        ),
      ),
      // Next button to go to the next scoring category
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: NextBackButton(
          buttonText: 'NEXT',
          onPressed: () {
            debugPrint('NEXT pressed');
          },
          font: font,
          bold: bold,
        ),
      ),
    ],
  );
}

void main() => runApp(const ElevatedButtonExampleApp());

class ElevatedButtonExampleApp extends StatelessWidget {
  const ElevatedButtonExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ElevatedButton Sample')),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background.webp'),
              repeat: ImageRepeat.repeat,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 10),
              getNewRow('Oswald'),
              const SizedBox(height: 10),
              getNewRow('Libre Franklin'),
              const SizedBox(height: 10),
              getNewRow('Public Sans'),
              const SizedBox(height: 10),
              getNewRow('Fjalla One'),
              const SizedBox(height: 10),
              getNewRow('Noto Sans'),
              const SizedBox(height: 10),
              getNewRow('Oswald', bold: true),
              const SizedBox(height: 10),
              getNewRow('Libre Franklin', bold: true),
              const SizedBox(height: 10),
              getNewRow('Public Sans', bold: true),
              const SizedBox(height: 10),
              getNewRow('Noto Sans', bold: true),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll(
                    EdgeInsets.fromLTRB(40, 17, 40, 18.5),
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
                onPressed: () {
                  debugPrint('BACH pressed');
                },
                child: Text(
                  'BACH',
                  style: TextStyle(
                    // for testing
                    fontFamily: 'FranklinGothicURW',
                    // end for testing
                    fontSize: 27.0,
                    //fontWeight: FontWeight.w100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
