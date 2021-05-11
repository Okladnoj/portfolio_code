class RepositoryHome {
  final String status;
  final RepositoryData data;

  RepositoryHome(
    this.status,
    this.data,
  );

  RepositoryHome.fromJson(Map<String, dynamic> json)
      : status = json['status'] as String,
        data = json['data'] != null ? RepositoryData.fromJson(json['data'] as Map<String, dynamic>) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class RepositoryData {
  final String farmName;
  final int activeCows;
  final int in24Seen;
  final int highTemp;
  final int sustainTemp;
  final int lowTemp;
  final int waterIntake;
  final int calving;
  final RepositoryLactationStages lactationStages;
  final RepositoryLactationStagesNames lactationStagesNames;
  final RepositoryLactationGroups lactationGroups;

  RepositoryData(
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

  RepositoryData.fromJson(Map<String, dynamic> json)
      : farmName = json['farmName'] as String,
        activeCows = json['activeCows'] as int,
        in24Seen = json['in24Seen'] as int,
        highTemp = json['highTemp'] as int,
        sustainTemp = json['sustainTemp'] as int,
        lowTemp = json['lowTemp'] as int,
        waterIntake = json['waterIntake'] as int,
        calving = json['calving'] as int,
        lactationStages = json['lactationStages'] != null
            ? RepositoryLactationStages.fromJson(json['lactationStages'] as Map<String, dynamic>)
            : null,
        lactationStagesNames = json['lactationStagesNames'] != null
            ? RepositoryLactationStagesNames.fromJson(json['lactationStagesNames'] as Map<String, dynamic>)
            : null,
        lactationGroups = json['lactationGroups'] != null
            ? RepositoryLactationGroups.fromJson(json['lactationGroups'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['farmName'] = farmName;
    data['activeCows'] = activeCows;
    data['in24Seen'] = in24Seen;
    data['highTemp'] = highTemp;
    data['sustainTemp'] = sustainTemp;
    data['lowTemp'] = lowTemp;
    data['waterIntake'] = waterIntake;
    data['calving'] = calving;
    if (lactationStages != null) {
      data['lactationStages'] = lactationStages.toJson();
    }
    data['lactationStagesNames'] = lactationStagesNames;
    if (lactationGroups != null) {
      data['lactationGroups'] = lactationGroups.toJson();
    }
    return data;
  }
}

class RepositoryLactationStages {
  final int noBred;
  final int preg;
  final int bred;
  final int okOpen;
  final int dry;
  final int fresh;

  RepositoryLactationStages(
    this.noBred,
    this.preg,
    this.bred,
    this.okOpen,
    this.dry,
    this.fresh,
  );

  RepositoryLactationStages.fromJson(Map<String, dynamic> json)
      : noBred = json['noBred'] as int,
        preg = json['preg'] as int,
        bred = json['bred'] as int,
        okOpen = json['okOpen'] as int,
        dry = json['dry'] as int,
        fresh = json['fresh'] as int;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['noBred'] = noBred;
    data['preg'] = preg;
    data['bred'] = bred;
    data['okOpen'] = okOpen;
    data['dry'] = dry;
    data['fresh'] = fresh;
    return data;
  }
}

class RepositoryLactationStagesNames {
  final String noBred;
  final String preg;
  final String bred;
  final String okOpen;
  final String dry;
  final String fresh;

  RepositoryLactationStagesNames(
    this.noBred,
    this.preg,
    this.bred,
    this.okOpen,
    this.dry,
    this.fresh,
  );

  RepositoryLactationStagesNames.fromJson(Map<String, dynamic> json)
      : noBred = json['noBred'] as String,
        preg = json['preg'] as String,
        bred = json['bred'] as String,
        okOpen = json['okOpen'] as String,
        dry = json['dry'] as String,
        fresh = json['fresh'] as String;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['noBred'] = noBred;
    data['preg'] = preg;
    data['bred'] = bred;
    data['okOpen'] = okOpen;
    data['dry'] = dry;
    data['fresh'] = fresh;
    return data;
  }
}

class RepositoryLactationGroups {
  final int g1;
  final int g2;
  final int g3;
  final int g4;
  final int g5;
  final int undefined;

  RepositoryLactationGroups(
    this.g1,
    this.g2,
    this.g3,
    this.g4,
    this.g5,
    this.undefined,
  );

  RepositoryLactationGroups.fromJson(Map<String, dynamic> json)
      : g1 = json['g1'] as int,
        g2 = json['g2'] as int,
        g3 = json['g3'] as int,
        g4 = json['g4'] as int,
        g5 = json['g5'] as int,
        undefined = json['undefined'] as int;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['g1'] = g1;
    data['g2'] = g2;
    data['g3'] = g3;
    data['g4'] = g4;
    data['g5'] = g5;
    data['undefined'] = undefined;
    return data;
  }
}
