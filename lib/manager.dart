import 'color.dart';
import 'bonus_stipulation.dart';
import 'cards_with_color.dart';

final List<Manager> allManagers = <Manager>[
  Manager(
    'The Handyman',
    Color.yellow,
    4,
    2,
    4,
    CardsWithColor(Color.yellow),
    true,
  ),
  Manager(
    'Sir Outrage',
    Color.teal,
    5,
    5,
    5,
    CardsWithColor(Color.teal),
    false,
  ),
  Manager(
    'The Nun',
    Color.orange,
    4,
    3,
    3,
    CardsWithColor(Color.orange),
    false,
  ),
  Manager('The Brain', Color.red, 3, 4, 3, CardsWithColor(Color.red), false),
  Manager('Sheikh', Color.purple, 4, 4, 2, CardsWithColor(Color.purple), false),
];

void setManagerIndices() {
  for (int i = 0; i < allManagers.length; ++i) {
    allManagers[i].index = i;
  }
}

class Manager {
  late int index;
  String name;
  Color color;
  int numberOfDefenders;
  int numberOfMidfielders;
  int numberOfForwards;

  BonusStipulation bonusStipulation;
  bool addOneToSymbolCounts;

  Manager(
    this.name,
    this.color,
    this.numberOfDefenders,
    this.numberOfMidfielders,
    this.numberOfForwards,
    this.bonusStipulation,
    this.addOneToSymbolCounts,
  );

  @override
  String toString() {
    return name;
  }
}
