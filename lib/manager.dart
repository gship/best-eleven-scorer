final List<Manager> allManagers = <Manager>[
  Manager(0, 'The Handyman', true, true, 0),
  Manager(1, 'Sir Outrage', false, false, -1),
  Manager(2, 'The Nun', false, true, 1),
  Manager(3, 'The Brain', false, true, 2),
  Manager(4, 'Sheikh', false, true, 3),
  Manager(5, 'Metalhead', false, true, 4),
  Manager(6, 'The Trailblazer', true, true, 5),
  Manager(7, 'The Special One', true, true, 6),
  Manager(8, 'The Boss', false, true, 7),
  Manager(9, 'Teodoro Reata', false, true, 8),
];

final List<Manager> allManagersWithFormations = <Manager>[
  allManagers[0],
  allManagers[1],
  allManagers[2],
  allManagers[3],
  allManagers[4],
  allManagers[5],
];

final List<Manager> allManagersWhichAreTiles = <Manager>[
  allManagers[0],
  allManagers[2],
  allManagers[3],
  allManagers[4],
  allManagers[5],
  allManagers[6],
  allManagers[7],
  allManagers[8],
  allManagers[9],
];

final List<Formation> allFormations = <Formation>[
  Formation(0, 4, 2, 4, 0),
  Formation(1, 5, 5, 5, -1),
  Formation(2, 4, 3, 3, 2),
  Formation(3, 3, 4, 3, 3),
  Formation(4, 4, 4, 2, 4),
  Formation(5, 3, 5, 2, 5),
];

final List<Formation> allFormationsForTiles = <Formation>[
  allFormations[0],
  allFormations[2],
  allFormations[3],
  allFormations[4],
  allFormations[5],
];

class Formation {
  final int index;
  final int numberOfDefenders;
  final int numberOfMidfielders;
  final int numberOfForwards;
  final int tileIndex;

  Formation(
    this.index,
    this.numberOfDefenders,
    this.numberOfMidfielders,
    this.numberOfForwards,
    this.tileIndex,
  );

  @override
  String toString() {
    return '$numberOfDefenders - $numberOfMidfielders - $numberOfForwards';
  }
}

class Manager {
  final int index;
  final String name;
  final bool addOneToSymbolCounts;
  final bool isTile;
  final int tileIndex;

  Manager(
    this.index,
    this.name,
    this.addOneToSymbolCounts,
    this.isTile,
    this.tileIndex,
  );

  @override
  String toString() {
    return name;
  }
}
