import '../lib/pages/manager_select_page.dart';
import 'package:flutter/material.dart';
import '../lib/team.dart';
import '../lib/core.dart';
import '../lib/routes.dart';

void main() async {
  // Initialize the database and insert users
  WidgetsFlutterBinding.ensureInitialized();
  initialize();
  core.currentPlayer = 0;
  Team team = Team('Glen');
  teams.add(team);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'FranklinGothicURW'),
      //theme: ThemeData(fontFamily: 'Providence'),
      //theme: ThemeData(fontFamily: GoogleFonts.publicSans().fontFamily),
      //theme: ThemeData(fontFamily: GoogleFonts.fuzzyBubbles().fontFamily),
      initialRoute: managerSelectPage,
      routes: {
        managerSelectPage: (context) => const ManagerSelectPage(),
      },
    );
  }
}
