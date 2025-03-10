import 'package:best_xi_scorer/pages/manager_select_page.dart';
import 'package:flutter/material.dart';
import '../team.dart';
import '../core.dart';
import '../routes.dart';

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
      initialRoute: Routes.managerSelectPage,
      routes: {
        Routes.managerSelectPage: (context) => const ManagerSelectPage(),
      },
    );
  }
}
