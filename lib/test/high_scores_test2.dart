import 'package:best_xi_scorer/pages/high_scores_page.dart';
import 'package:flutter/material.dart';
import '../high_scores.dart';
import '../core.dart';

void main() async {

  // Initialize the database and insert users
  WidgetsFlutterBinding.ensureInitialized();
  initialize();

  await highScores.isHighScore('Glen', 127);
  await highScores.isHighScore('Sheila', 120);
  await highScores.isHighScore('Matt', 100);
  await highScores.isHighScore('Brigham', 97);
  await highScores.isHighScore('Jehosaphat', 93);
  await highScores.isHighScore('Grandmaster Funk', 91);
  await highScores.isHighScore('Glen', 121);
  await highScores.isHighScore('Sheila', 118);
  await highScores.isHighScore('Matt', 99);
  await highScores.isHighScore('Brigham', 96);
  await highScores.isHighScore('Jehosaphat', 89);
  await highScores.isHighScore('Grandmaster Funk', 87);

  runApp(HighScoresPage());
}

