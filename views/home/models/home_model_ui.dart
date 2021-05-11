import 'package:flutter/cupertino.dart';

import 'home_model.dart';

class HomeModelUI {
  final CurrentPeriod currentPeriod;
  final String farmName;
  final int activeCows;
  final int in24Seen;
  final MonitorModelUI highTemp;
  final MonitorModelUI sustainTemp;
  final MonitorModelUI lowTemp;
  final MonitorModelUI waterIntake;
  final MonitorModelUI calving;
  final List<GroupsModelUI> groups;
  final List<LactationModelUI> lactationStages;

  HomeModelUI({
    @required this.currentPeriod,
    @required this.farmName,
    @required this.activeCows,
    @required this.in24Seen,
    @required this.highTemp,
    @required this.sustainTemp,
    @required this.lowTemp,
    @required this.waterIntake,
    @required this.calving,
    @required this.groups,
    @required this.lactationStages,
  });
}

class GroupsModelUI {
  final String name;
  final int value;

  GroupsModelUI({
    @required this.name,
    @required this.value,
  });
}

class LactationModelUI {
  final String name;
  final int value;

  LactationModelUI({
    @required this.name,
    @required this.value,
  });
}

class MonitorModelUI {
  final String name;
  final int value;

  MonitorModelUI({
    @required this.name,
    @required this.value,
  });
}
