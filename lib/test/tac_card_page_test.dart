import 'package:flutter/material.dart';
import '../pages/tac_card_page.dart';
import '../core.dart';
import '../team.dart';

void main() {
  core.currentPlayer = 0;
  core.numPlayers = 1;
  teams.add(Team('Glen'));
  debugPrint('calling runApp');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const TacCardPage(),
    );
  }
}
