import 'package:flutter/material.dart';
import 'team.dart';

// need to position each component of score
Positioned positionedFittedBox(
  double left,
  double top,
  double width,
  double height,
  String text,
  Color backgroundColor, {
  bool topRound = false,
  bool bottomRound = false,
}) {
  return Positioned(
    left: left,
    top: top,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(topRound ? 10 : 0), // Add rounded corner
          bottomRight: Radius.circular(
            bottomRound ? 10 : 0,
          ), // Add rounded corner
        ),
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Providence',
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.black,
            /*
              fontSize: 26,
              fontFamily: GoogleFonts.fuzzyBubbles().fontFamily,
               */
          ),
        ),
      ),
    ),
  );
}

// this is the stack of positioned components for a team
List<Widget> teamStack(List<Team> teams, int index) {
  double left =
      55.9 +
      (index.toDouble() * 67.4); // this is why index is needed and not team
  double top = 1.5;
  double width = 65.3;
  double height = 44.75;
  Color backgroundColor =
      teams[index].score.isHighScore || teams[index].score.isSoloWin
          ? Colors.yellow
          : Colors.white;

  double vertical = 46.68;

  return [
    positionedFittedBox(
      left,
      top,
      width,
      height,
      teams[index].gamePlayer,
      backgroundColor,
      topRound: (index == 3) ? true : false,
    ),
    positionedFittedBox(
      left,
      top += vertical,
      width,
      height,
      '${teams[index].score.money}',
      backgroundColor,
    ),
    positionedFittedBox(
      left,
      top += vertical,
      width,
      height,
      '${teams[index].score.tacCards}',
      backgroundColor,
    ),
    positionedFittedBox(
      left,
      top += vertical,
      width,
      height,
      '${teams[index].score.speed}',
      backgroundColor,
    ),
    positionedFittedBox(
      left,
      top += vertical,
      width,
      height,
      '${teams[index].score.savvy}',
      backgroundColor,
    ),
    positionedFittedBox(
      left,
      top += vertical,
      width,
      height,
      '${teams[index].score.strength}',
      backgroundColor,
    ),
    positionedFittedBox(
      left,
      top += vertical,
      width,
      height,
      '${teams[index].score.skill}',
      backgroundColor,
    ),
    positionedFittedBox(
      left,
      top += vertical,
      width,
      height,
      '${teams[index].score.base}',
      backgroundColor,
    ),
    positionedFittedBox(
      left,
      top += vertical,
      width,
      height,
      '${teams[index].score.total}',
      backgroundColor,
      bottomRound: (index == 3) ? true : false,
    ),
  ];
}

// this is all the teams' stacks
List<Widget> scoreStack(List<Team> teams) {
  List<Widget> retList = [];

  for (int index = 0; index < teams.length; ++index) {
    retList.addAll(teamStack(teams, index));
  }

  return retList;
}

Row scorePad(List<Team> teams, MainAxisAlignment mainAxisAlignment) {
  return Row(
    mainAxisAlignment: mainAxisAlignment,
    children: [
      (mainAxisAlignment == MainAxisAlignment.start)
          ? const SizedBox(width: 20)
          : const SizedBox(width: 0),
      SizedBox(
        //width: 300.0,
        //height: 432.0,
        width: 324.6666666666667,
        height: 421.3333333333333,
        child: DecoratedBox(
          // BoxDecoration takes the image
          decoration: BoxDecoration(
            // Image set to background of the body
            image: DecorationImage(
              image: AssetImage('images/score_pad.webp'),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(children: scoreStack(teams)),
        ),
      ),
    ],
  );
}
