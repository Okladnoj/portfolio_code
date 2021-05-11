import 'collection.dart';

export 'collection.dart';

class HerdChartsModel {
  final WaterModel water;
  final TemperatureModel temperature;

  HerdChartsModel(
    this.water,
    this.temperature,
  );

  factory HerdChartsModel.empty() => HerdChartsModel(
        null,
        null,
      );

  HerdChartsModel copy({
    WaterModel water,
    TemperatureModel temperature,
    bool isLoad,
  }) {
    return HerdChartsModel(
      water ?? this.water,
      temperature ?? this.temperature,
    );
  }
}

class WaterModel {
  final TimeInterval timeInterval;
  final SubGroupOfCharts subGroup;
  final GroupsModel groups;
  final LactationsModel lactations;
  final DateTime date;
  final bool isLoad;

  WaterModel(
    this.timeInterval,
    this.subGroup,
    this.groups,
    this.lactations,
    this.date,
    this.isLoad,
  );

  WaterModel copy({
    TimeInterval timeInterval,
    SubGroupOfCharts subGroup,
    GroupsModel groups,
    LactationsModel lactations,
    DateTime date,
    bool isLoad,
  }) {
    return WaterModel(
      timeInterval ?? this.timeInterval,
      subGroup ?? this.subGroup,
      groups ?? this.groups,
      lactations ?? this.lactations,
      date ?? this.date,
      isLoad ?? this.isLoad,
    );
  }
}

class TemperatureModel {
  final TimeInterval timeInterval;
  final SubGroupOfCharts subGroup;
  final GroupsModel groups;
  final LactationsModel lactations;
  final DateTime date;
  final bool isLoad;

  TemperatureModel(
    this.timeInterval,
    this.subGroup,
    this.groups,
    this.lactations,
    this.date,
    this.isLoad,
  );

  TemperatureModel copy({
    TimeInterval timeInterval,
    SubGroupOfCharts subGroup,
    GroupsModel groups,
    LactationsModel lactations,
    DateTime date,
    bool isLoad,
  }) {
    return TemperatureModel(
      timeInterval ?? this.timeInterval,
      subGroup ?? this.subGroup,
      groups ?? this.groups,
      lactations ?? this.lactations,
      date ?? this.date,
      isLoad ?? this.isLoad,
    );
  }
}

class GroupsModel {
  final GroupsDaysModel groupsDays;
  final GroupsHoursModel groupsHours;

  GroupsModel(
    this.groupsDays,
    this.groupsHours,
  );

  GroupsModel copy({
    List<ActionLineOfGroups> listActionLineOfGroups,
    GroupsDaysModel groupsDays,
    GroupsHoursModel groupsHours,
  }) {
    return GroupsModel(
      groupsDays ?? this.groupsDays,
      groupsHours ?? this.groupsHours,
    );
  }
}

class GroupsDaysModel {
  final List<int> day;
  final GraphicModel g1;
  final GraphicModel g2;
  final GraphicModel g3;
  final GraphicModel g4;
  final GraphicModel g5;
  final GraphicModel undefined;
  final GraphicModel total;
  final GraphicModel outside;

  GroupsDaysModel(
    this.day,
    this.g1,
    this.g2,
    this.g3,
    this.g4,
    this.g5,
    this.undefined,
    this.total,
    this.outside,
  );

  GroupsDaysModel copy({
    List<int> day,
    GraphicModel g1,
    GraphicModel g2,
    GraphicModel g3,
    GraphicModel g4,
    GraphicModel g5,
    GraphicModel undefined,
    GraphicModel total,
    GraphicModel outside,
  }) {
    return GroupsDaysModel(
      day ?? this.day,
      g1 ?? this.g1,
      g2 ?? this.g2,
      g3 ?? this.g3,
      g4 ?? this.g4,
      g5 ?? this.g5,
      undefined ?? this.undefined,
      total ?? this.total,
      outside ?? this.outside,
    );
  }
}

class GroupsHoursModel {
  final List<int> hour;
  final GraphicModel g1;
  final GraphicModel g2;
  final GraphicModel g3;
  final GraphicModel g4;
  final GraphicModel g5;
  final GraphicModel undefined;
  final GraphicModel total;
  final GraphicModel outside;

  GroupsHoursModel(
    this.hour,
    this.g1,
    this.g2,
    this.g3,
    this.g4,
    this.g5,
    this.undefined,
    this.total,
    this.outside,
  );

  GroupsHoursModel copy({
    List<int> hour,
    GraphicModel g1,
    GraphicModel g2,
    GraphicModel g3,
    GraphicModel g4,
    GraphicModel g5,
    GraphicModel undefined,
    GraphicModel total,
    GraphicModel outside,
  }) {
    return GroupsHoursModel(
      hour ?? this.hour,
      g1 ?? this.g1,
      g2 ?? this.g2,
      g3 ?? this.g3,
      g4 ?? this.g4,
      g5 ?? this.g5,
      undefined ?? this.undefined,
      total ?? this.total,
      outside ?? this.outside,
    );
  }
}

class LactationsModel {
  final LactationsDaysModel lactationsDays;
  final LactationsHoursModel lactationsHours;

  LactationsModel(
    this.lactationsDays,
    this.lactationsHours,
  );

  LactationsModel copy({
    List<ActionLineOfLactations> listActionLineOfLactations,
    LactationsDaysModel lactationsDays,
    LactationsHoursModel lactationsHours,
  }) {
    return LactationsModel(
      lactationsDays ?? this.lactationsDays,
      lactationsHours ?? this.lactationsHours,
    );
  }
}

class LactationsDaysModel {
  final List<int> day;
  final GraphicModel bred;
  final GraphicModel dry;
  final GraphicModel fresh;
  final GraphicModel noBred;
  final GraphicModel okOpen;
  final GraphicModel preg;
  final GraphicModel undefined;
  final GraphicModel total;
  final GraphicModel outside;

  LactationsDaysModel(
    this.day,
    this.bred,
    this.dry,
    this.fresh,
    this.noBred,
    this.okOpen,
    this.preg,
    this.undefined,
    this.total,
    this.outside,
  );

  LactationsDaysModel copy({
    List<int> day,
    GraphicModel bred,
    GraphicModel dry,
    GraphicModel fresh,
    GraphicModel noBred,
    GraphicModel okOpen,
    GraphicModel preg,
    GraphicModel undefined,
    GraphicModel total,
    GraphicModel outside,
  }) {
    return LactationsDaysModel(
      day ?? this.day,
      bred ?? this.bred,
      dry ?? this.dry,
      fresh ?? this.fresh,
      noBred ?? this.noBred,
      okOpen ?? this.okOpen,
      preg ?? this.preg,
      undefined ?? this.undefined,
      total ?? this.total,
      outside ?? this.outside,
    );
  }
}

class LactationsHoursModel {
  final List<int> hour;
  final GraphicModel bred;
  final GraphicModel dry;
  final GraphicModel fresh;
  final GraphicModel noBred;
  final GraphicModel okOpen;
  final GraphicModel preg;
  final GraphicModel undefined;
  final GraphicModel total;
  final GraphicModel outside;

  LactationsHoursModel(
    this.hour,
    this.bred,
    this.dry,
    this.fresh,
    this.noBred,
    this.okOpen,
    this.preg,
    this.undefined,
    this.total,
    this.outside,
  );

  LactationsHoursModel copy({
    List<int> hour,
    GraphicModel bred,
    GraphicModel dry,
    GraphicModel fresh,
    GraphicModel noBred,
    GraphicModel okOpen,
    GraphicModel preg,
    GraphicModel undefined,
    GraphicModel total,
    GraphicModel outside,
  }) {
    return LactationsHoursModel(
      hour ?? this.hour,
      bred ?? this.bred,
      dry ?? this.dry,
      fresh ?? this.fresh,
      noBred ?? this.noBred,
      okOpen ?? this.okOpen,
      preg ?? this.preg,
      undefined ?? this.undefined,
      total ?? this.total,
      outside ?? this.outside,
    );
  }
}

class GraphicModel {
  final String name;
  final List<double> data;
  final String type;
  final String color;
  final bool isShow;

  GraphicModel(
    this.name,
    this.data,
    this.type,
    this.color,
    this.isShow,
  );

  GraphicModel copy({
    String name,
    List<double> data,
    String type,
    String color,
    bool isShow,
  }) {
    return GraphicModel(
      name ?? this.name,
      data ?? this.data,
      type ?? this.type,
      color ?? this.color,
      isShow ?? this.isShow,
    );
  }
}
