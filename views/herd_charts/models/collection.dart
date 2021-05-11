import 'package:flutter/cupertino.dart';

enum TimeInterval {
  day,
  hour,
}

enum SubGroupOfCharts {
  lactations,
  groups,
}

enum ActionLineOfGroups {
  g1,
  g2,
  g3,
  g4,
  g5,
  undefined,
  total,
  outside,
}

enum ActionLineOfLactations {
  bred,
  dry,
  fresh,
  noBred,
  okOpen,
  preg,
  undefined,
  total,
  outside,
}

class ColorsCollection {
  static Map<ActionLineOfLactations, String> lactationsSet = {
    ActionLineOfLactations.bred: '#6341F0',
    ActionLineOfLactations.dry: '#2D82F7',
    ActionLineOfLactations.fresh: '#34E0D9',
    ActionLineOfLactations.noBred: '#2DF76B',
    ActionLineOfLactations.okOpen: '#9AF007',
    ActionLineOfLactations.preg: '#F0D035',
    ActionLineOfLactations.undefined: '#E05928',
    ActionLineOfLactations.total: '#C42BF0',
    ActionLineOfLactations.outside: '#FA372F',
  };

  static Map<ActionLineOfGroups, String> groupsSet = {
    ActionLineOfGroups.g1: '#6341F0',
    ActionLineOfGroups.g2: '#2D82F7',
    ActionLineOfGroups.g3: '#34E0D9',
    ActionLineOfGroups.g4: '#2DF76B',
    ActionLineOfGroups.g5: '#9AF007',
    ActionLineOfGroups.undefined: '#F0D035',
    ActionLineOfGroups.total: '#E05928',
    ActionLineOfGroups.outside: '#C42BF0',
  };

  static Color color(dynamic en) {
    String string = '';
    if (en is ActionLineOfGroups) {
      string = groupsSet[en];
    } else if (en is ActionLineOfLactations) {
      string = lactationsSet[en];
    }
    final color = int.parse(string.replaceAll('#', ''), radix: 16);
    return Color(0xFF000000 + color);
  }
}
