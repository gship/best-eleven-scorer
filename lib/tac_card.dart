import 'bonus_stipulation.dart';
import 'high_low_base_points.dart';
import 'no_symbols.dart';
import 'sets_of_symbols_across_lines.dart';
import 'the_in_the_name.dart';
import 'cards_in_hand.dart';
import 'base_points_equal_one.dart';
import 'with_signing_bonus.dart';
import 'sets_of_colors_across_lines.dart';
import 'multiple_positions.dart';
import 'sets_of_colors.dart';
import 'sets_of_symbols.dart';
import 'cards_with_color.dart';
import 'color.dart';
import 'no_cards_with_symbol.dart';
import 'symbol.dart';
import 'money.dart';
import 'color_of_keeper.dart';

final List<TacCard> allTacCards = <TacCard>[
  TacCard('BENCH BOOST', 0, highLowBasePoints),
  TacCard('CANARIES', 0, CardsWithColor(Color.yellow)),
  // 4 IF 3-4CARDS, 7 IF 5+CARDS
  TacCard('DAVIDS', 7, NoCardsWithSymbol(Symbol.strength)),
  TacCard('DOUBLE THE ODDS', 1, money),
  TacCard('DUMB LUCK', 7, NoCardsWithSymbol(Symbol.savvy)),
  TacCard('FURIA ROJA', 0, CardsWithColor(Color.red)),
  // 4 IF 3-4CARDS, 7 IF 5+CARDS
  TacCard('HARMONY', 0, setsOfSymbols),
  // 4 FOR 1, 15 FOR 2
  TacCard('KEEP SHAPE', 4, setsOfSymbolsAcrossLines),
  TacCard('LA VIOLAS', 0, CardsWithColor(Color.purple)),
  // 4 IF 3-4CARDS, 7 IF 5+CARDS
  TacCard('MIXED BAG', 0, setsOfColors),
  // 5 FOR 1, 12 FOR 2
  TacCard('ORANGE SPINE', 4, setsOfColorsAcrossLines),
  // 5 FOR 1, 15 FOR 2
  TacCard('ORANJE', 0, CardsWithColor(Color.orange)),
  // 4 IF 3-4CARDS, 7 IF 5+CARDS
  TacCard('PEACOCKING', 0, CardsWithColor(Color.teal)),
  // 4 IF 3-4CARDS, 7 IF 5+CARDS
  TacCard('PURPLE SPINE', 4, setsOfColorsAcrossLines),
  // 5 FOR 1, 15 FOR 2
  TacCard('RED SPINE', 4, setsOfColorsAcrossLines),
  // 5 FOR 1, 15 FOR 2
  TacCard('SIGN ME UP', 0, withSigningBonus),
  // 3 IF 4-5CARDS, 6 IF 6+CARDS
  TacCard('SKILLET', 7, NoCardsWithSymbol(Symbol.skill)),
  TacCard('SLOW AND STEADY', 7, NoCardsWithSymbol(Symbol.speed)),
  TacCard('TEAL SPINE', 4, setsOfColorsAcrossLines),
  // 5 FOR 1, 15 FOR 2
  TacCard('"THE" CARD', 0, theInTheName),
  // 3 IF 3-4CARDS, 5 IF 5+CARDS
  TacCard('THE HOLDOVERS', 0, cardsInHand),
  // 5 IF 3CARDS, 8 IF 4+CARDS
  TacCard('THEY\'RE KEEPERS', 2, ColorOfKeeper()),
  TacCard('UNDERDOGS', 2, noSymbols),
  TacCard('UTILITY PLAYERS', 2, multiplePositions),
  // 3 IF 3-4CARDS, 6 IF 5+CARDS
  TacCard('WE\'RE #1', 0, basePointsEqualOne),
  // 4 IF 3-4CARDS, 7 IF 5+CARDS
  TacCard('YELLOW SPINE', 4, setsOfColorsAcrossLines),
  // 5 FOR 1, 15 FOR 2
];

void setTacCardIndices() {
  for (int i = 0; i < allTacCards.length; ++i) {
    allTacCards[i].index = i;
  }
}

class TacCard {
  late int index;
  String name;
  int bonusPoints;
  BonusStipulation bonusStipulation;

  TacCard(this.name, this.bonusPoints, this.bonusStipulation);

  String toValuesString() {
    return '$index)';
  }

  @override
  String toString() {
    return name;
  }
}
