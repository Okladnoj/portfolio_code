enum CurrentPeriod {
  in24,
  week,
}

class HomeModels {
  final String status;
  final CurrentPeriod currentPeriod;
  final HomeModel homeModel24h;
  final HomeModel homeModelWeek;

  HomeModels(
    this.status,
    this.currentPeriod,
    this.homeModel24h,
    this.homeModelWeek,
  );

  HomeModels copy({
    String status,
    CurrentPeriod currentPeriod,
    HomeModel homeModel24h,
    HomeModel homeModelWeek,
  }) {
    return HomeModels(
      status ?? this.status,
      currentPeriod ?? this.currentPeriod,
      homeModel24h ?? this.homeModel24h,
      homeModelWeek ?? this.homeModelWeek,
    );
  }
}

class HomeModel {
  final String farmName;
  final int activeCows;
  final int in24Seen;
  final int highTemp;
  final int sustainTemp;
  final int lowTemp;
  final int waterIntake;
  final int calving;
  final LactationStagesModel lactationStages;
  final LactationStagesNamesModel lactationStagesNames;
  final LactationGroupsModel lactationGroups;

  HomeModel(
    this.farmName,
    this.activeCows,
    this.in24Seen,
    this.highTemp,
    this.sustainTemp,
    this.lowTemp,
    this.waterIntake,
    this.calving,
    this.lactationStages,
    this.lactationStagesNames,
    this.lactationGroups,
  );

  HomeModel copy({
    String farmName,
    int activeCows,
    int in24Seen,
    int highTemp,
    int sustainTemp,
    int lowTemp,
    int waterIntake,
    int calving,
    LactationStagesModel lactationStages,
    LactationStagesNamesModel lactationStagesNames,
    LactationGroupsModel lactationGroups,
  }) {
    return HomeModel(
      farmName ?? this.farmName,
      activeCows ?? this.activeCows,
      in24Seen ?? this.in24Seen,
      highTemp ?? this.highTemp,
      sustainTemp ?? this.sustainTemp,
      lowTemp ?? this.lowTemp,
      waterIntake ?? this.waterIntake,
      calving ?? this.calving,
      lactationStages ?? this.lactationStages,
      lactationStagesNames ?? this.lactationStagesNames,
      lactationGroups ?? this.lactationGroups,
    );
  }
}

class LactationStagesModel {
  final int noBred;
  final int preg;
  final int bred;
  final int okOpen;
  final int dry;
  final int fresh;

  LactationStagesModel(
    this.noBred,
    this.preg,
    this.bred,
    this.okOpen,
    this.dry,
    this.fresh,
  );

  LactationStagesModel copy({
    int noBred,
    int preg,
    int bred,
    int okOpen,
    int dry,
    int fresh,
  }) {
    return LactationStagesModel(
      noBred ?? this.noBred,
      preg ?? this.preg,
      bred ?? this.bred,
      okOpen ?? this.okOpen,
      dry ?? this.dry,
      fresh ?? this.fresh,
    );
  }
}

class LactationStagesNamesModel {
  final String noBred;
  final String preg;
  final String bred;
  final String okOpen;
  final String dry;
  final String fresh;

  LactationStagesNamesModel(
    this.noBred,
    this.preg,
    this.bred,
    this.okOpen,
    this.dry,
    this.fresh,
  );

  LactationStagesNamesModel copy({
    String noBred,
    String preg,
    String bred,
    String okOpen,
    String dry,
    String fresh,
  }) {
    return LactationStagesNamesModel(
      noBred ?? this.noBred,
      preg ?? this.preg,
      bred ?? this.bred,
      okOpen ?? this.okOpen,
      dry ?? this.dry,
      fresh ?? this.fresh,
    );
  }
}

class LactationGroupsModel {
  final int g1;
  final int g2;
  final int g3;
  final int g4;
  final int g5;
  final int undefined;

  LactationGroupsModel(
    this.g1,
    this.g2,
    this.g3,
    this.g4,
    this.g5,
    this.undefined,
  );

  LactationGroupsModel copy({
    int g1,
    int g2,
    int g3,
    int g4,
    int g5,
    int undefined,
  }) {
    return LactationGroupsModel(
      g1 ?? this.g1,
      g2 ?? this.g2,
      g3 ?? this.g3,
      g4 ?? this.g4,
      g5 ?? this.g5,
      undefined ?? this.undefined,
    );
  }
}
