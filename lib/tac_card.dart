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
import 'position.dart';
import 'all_cards_the_same_points.dart';
import 'only_one_kind_of_symbol.dart';
import 'same_number_of_each_kind_of_symbol.dart';
import 'only_two_colors.dart';
import 'all_odd_or_all_even_numbered_cards.dart';
import 'more_cards_of_color_than_any_other_player.dart';
import 'all_position_same_point_value.dart';

enum TacCardDependency { color, symbol, none }

final List<TacCard> allTacCards = <TacCard>[
  TacCard(0, 'ALL IN ALL', allCardsTheSamePoints, TacCardDependency.none),
  // 25 IF TRUE, -7 IF FALSE
  TacCard(1, 'BALANCED D', AllPositionSamePointValue(Position.defender), TacCardDependency.none),
  // 5 IF TRUE
  TacCard(2, 'BENCH BOOST', highLowBasePoints, TacCardDependency.none),
  TacCard(3, 'CANARIES', CardsWithColor(Color.yellow), TacCardDependency.color),
  // 4 IF 3-4CARDS, 7 IF 5+CARDS
  TacCard(
    4,
    'CLOCKWORK',
    MoreCardsOfColorThanAnyOtherPlayerColor(Color.orange),
    TacCardDependency.color
  ),
  // 6 IF TWO PLAYERS, 9 IF THREE PLAYERS, 12 IF FOUR PLAYERS
  TacCard(5, 'DAVIDS', NoCardsWithSymbol(Symbol.strength), TacCardDependency.symbol),
  TacCard(6, 'DOUBLE THE ODDS', money, TacCardDependency.none),
  TacCard(7, 'DUMB LUCK', NoCardsWithSymbol(Symbol.savvy), TacCardDependency.symbol),
  TacCard(8, 'EVEN STRIKE', AllPositionSamePointValue(Position.forward), TacCardDependency.none),
  // 5 IF TRUE
  TacCard(9, 'FURIA ROJA', CardsWithColor(Color.red), TacCardDependency.color),
  // 4 IF 3-4CARDS, 7 IF 5+CARDS
  TacCard(10, 'HARMONY', setsOfSymbols, TacCardDependency.symbol),
  // 4 FOR 1, 15 FOR 2
  TacCard(
    11,
    'IT WAS ALL',
    MoreCardsOfColorThanAnyOtherPlayerColor(Color.yellow),
    TacCardDependency.color
  ),
  // 6 IF TWO PLAYERS, 9 IF THREE PLAYERS, 12 IF FOUR PLAYERS
  TacCard(12, 'KEEP SHAPE', setsOfSymbolsAcrossLines, TacCardDependency.symbol),
  TacCard(13, 'LA VIOLAS', CardsWithColor(Color.purple), TacCardDependency.color),
  // 4 IF 3-4CARDS, 7 IF 5+CARDS
  TacCard(14, 'LEVEL MIDFIELD', AllPositionSamePointValue(Position.midfielder), TacCardDependency.none),
  // 5 IF TRUE
  TacCard(15, 'LEVELED UP', sameNumberOfEachKindOfSymbol, TacCardDependency.symbol),
  // 25 IF TRUE, -7 IF FALSE
  TacCard(
    16,
    'ME ABOUT IT',
    MoreCardsOfColorThanAnyOtherPlayerColor(Color.teal),
    TacCardDependency.color
  ),
  // 6 IF TWO PLAYERS, 9 IF THREE PLAYERS, 12 IF FOUR PLAYERS
  TacCard(17, 'MIXED BAG', setsOfColors, TacCardDependency.color),
  // 5 FOR 1, 12 FOR 2
  TacCard(18, 'ONE TRACK', onlyOneKindOfSymbol, TacCardDependency.symbol),
  // 25 IF TRUE, -7 IF FALSE
  TacCard(19, 'ORANGE SPINE', SetsOfColorsAcrossLines(Color.orange), TacCardDependency.color),
  // 5 FOR 1, 15 FOR 2
  TacCard(20, 'ORANJE', CardsWithColor(Color.orange), TacCardDependency.color),
  // 4 IF 3-4CARDS, 7 IF 5+CARDS
  TacCard(
    21,
    'PAINT THE TOWN',
    MoreCardsOfColorThanAnyOtherPlayerColor(Color.red),
    TacCardDependency.color
  ),
  // 6 IF TWO PLAYERS, 9 IF THREE PLAYERS, 12 IF FOUR PLAYERS
  TacCard(22, 'PARITY PARTY', allOddOrAllEvenNumberedCards, TacCardDependency.none),
  // 20 IF TRUE, -5 IF FALSE
  TacCard(23, 'PEACOCKING', CardsWithColor(Color.teal), TacCardDependency.color),
  // 4 IF 3-4CARDS, 7 IF 5+CARDS
  TacCard(
    24,
    'PEOPLE EATERS',
    MoreCardsOfColorThanAnyOtherPlayerColor(Color.purple),
    TacCardDependency.color
  ),
  // 6 IF TWO PLAYERS, 9 IF THREE PLAYERS, 12 IF FOUR PLAYERS
  TacCard(25, 'PURPLE SPINE', SetsOfColorsAcrossLines(Color.purple), TacCardDependency.color),
  // 5 FOR 1, 15 FOR 2
  TacCard(26, 'RED SPINE', SetsOfColorsAcrossLines(Color.red), TacCardDependency.color),
  // 5 FOR 1, 15 FOR 2
  TacCard(27, 'SIGN ME UP', withSigningBonus, TacCardDependency.none),
  // 3 IF 4-5CARDS, 6 IF 6+CARDS
  TacCard(28, 'SKILLET', NoCardsWithSymbol(Symbol.skill), TacCardDependency.symbol),
  TacCard(29, 'SLOW AND STEADY', NoCardsWithSymbol(Symbol.speed), TacCardDependency.symbol),
  TacCard(30, 'TEAL SPINE', SetsOfColorsAcrossLines(Color.teal), TacCardDependency.color),
  // 5 FOR 1, 15 FOR 2
  TacCard(31, '"THE" CARD', theInTheName, TacCardDependency.none),
  // 3 IF 3-4CARDS, 5 IF 5+CARDS
  TacCard(32, 'THE HOLDOVERS', cardsInHand, TacCardDependency.none),
  // 5 IF 3CARDS, 8 IF 4+CARDS
  TacCard(33, 'THEY\'RE KEEPERS', ColorOfKeeper(), TacCardDependency.color),
  TacCard(34, 'TWO TONED', onlyTwoColors, TacCardDependency.color),
  // 20 IF TRUE, -5 IF FALSE
  TacCard(35, 'UNDERDOGS', noSymbols, TacCardDependency.symbol),
  TacCard(36, 'UTILITY PLAYERS', multiplePositions, TacCardDependency.none),
  // 3 IF 3-4CARDS, 6 IF 5+CARDS
  TacCard(37, 'WE\'RE #1', basePointsEqualOne, TacCardDependency.none),
  // 4 IF 3-4CARDS, 7 IF 5+CARDS
  TacCard(38, 'YELLOW SPINE', SetsOfColorsAcrossLines(Color.yellow), TacCardDependency.color),
  // 5 FOR 1, 15 FOR 2
];

class TacCard {
  final int index;
  final String name;
  final BonusStipulation bonusStipulation;
  final TacCardDependency dependency;

  TacCard(this.index, this.name, this.bonusStipulation, this.dependency);

  String toValuesString() {
    return '$index)';
  }

  @override
  String toString() {
    return name;
  }
}
