import 'herd_charts_model.dart';

class HerdChartsModelUI {
  final WaterModelUI water;
  final TemperatureModelUI temperature;

  HerdChartsModelUI(
    this.water,
    this.temperature,
  );
}

class WaterModelUI {
  final TimeInterval timeInterval;
  final SubGroupOfCharts subGroup;
  final GroupsModelUI groups;
  final LactationsModelUI lactations;
  final DateTime date;
  final bool isLoad;

  WaterModelUI(
    this.timeInterval,
    this.subGroup,
    this.groups,
    this.lactations,
    this.date,
    this.isLoad,
  );
}

class TemperatureModelUI {
  final TimeInterval timeInterval;
  final SubGroupOfCharts subGroup;
  final GroupsModelUI groups;
  final LactationsModelUI lactations;
  final DateTime date;
  final bool isLoad;

  TemperatureModelUI(
    this.timeInterval,
    this.subGroup,
    this.groups,
    this.lactations,
    this.date,
    this.isLoad,
  );
}

class GroupsModelUI {
  final GroupsDaysModelUI groupsDays;
  final GroupsHoursModelUI groupsHours;

  GroupsModelUI(
    this.groupsDays,
    this.groupsHours,
  );
}

class GroupsDaysModelUI {
  final List<int> day;
  final GraphicModelUI g1;
  final GraphicModelUI g2;
  final GraphicModelUI g3;
  final GraphicModelUI g4;
  final GraphicModelUI g5;
  final GraphicModelUI undefined;
  final GraphicModelUI total;
  final GraphicModelUI outside;

  GroupsDaysModelUI(
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
}

class GroupsHoursModelUI {
  final List<int> hour;
  final GraphicModelUI g1;
  final GraphicModelUI g2;
  final GraphicModelUI g3;
  final GraphicModelUI g4;
  final GraphicModelUI g5;
  final GraphicModelUI undefined;
  final GraphicModelUI total;
  final GraphicModelUI outside;

  GroupsHoursModelUI(
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
}

class LactationsModelUI {
  final LactationsDaysModelUI lactationsDays;
  final LactationsHoursModelUI lactationsHours;

  LactationsModelUI(
    this.lactationsDays,
    this.lactationsHours,
  );
}

class LactationsDaysModelUI {
  final List<int> day;
  final GraphicModelUI bred;
  final GraphicModelUI dry;
  final GraphicModelUI fresh;
  final GraphicModelUI noBred;
  final GraphicModelUI okOpen;
  final GraphicModelUI preg;
  final GraphicModelUI undefined;
  final GraphicModelUI total;
  final GraphicModelUI outside;

  LactationsDaysModelUI(
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
}

class LactationsHoursModelUI {
  final List<int> hour;
  final GraphicModelUI bred;
  final GraphicModelUI dry;
  final GraphicModelUI fresh;
  final GraphicModelUI noBred;
  final GraphicModelUI okOpen;
  final GraphicModelUI preg;
  final GraphicModelUI undefined;
  final GraphicModelUI total;
  final GraphicModelUI outside;

  LactationsHoursModelUI(
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
}

class GraphicModelUI {
  final String name;
  final List<double> data;
  final String type;
  final String color;
  final bool isShow;

  GraphicModelUI(
    this.name,
    this.data,
    this.type,
    this.color,
    this.isShow,
  );
}
