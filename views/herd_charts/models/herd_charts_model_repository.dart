import 'interface/interface.dart';

class HerdChartsModelRepository {
  final WaterModelRepository water;
  final TemperatureModelRepository temperature;

  HerdChartsModelRepository(
    this.water,
    this.temperature,
  );

  HerdChartsModelRepository.fromJson(Map<String, dynamic> json)
      : water = _safeWater(json),
        temperature = _safeTemperature(json);

  static WaterModelRepository _safeWater(Map<String, dynamic> json) =>
      json['water'] != null ? WaterModelRepository.fromJson(json['water'] as Map<String, dynamic>) : null;

  static TemperatureModelRepository _safeTemperature(Map<String, dynamic> json) => json['temperature'] != null
      ? TemperatureModelRepository.fromJson(json['temperature'] as Map<String, dynamic>)
      : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (water != null) {
      data['water'] = water.toJson();
    }
    if (temperature != null) {
      data['temperature'] = temperature.toJson();
    }
    return data;
  }
}

class WaterModelRepository {
  final GroupsModelRepository groups;
  final LactationsModelRepository lactations;

  WaterModelRepository(
    this.groups,
    this.lactations,
  );

  WaterModelRepository.fromJson(Map<String, dynamic> json)
      : groups = _safeGroups(json),
        lactations = _safeLactations(json);

  static LactationsModelRepository _safeLactations(Map<String, dynamic> json) => json['lactations'] != null
      ? LactationsModelRepository.fromJson(json['lactations'] as Map<String, dynamic>)
      : null;

  static GroupsModelRepository _safeGroups(Map<String, dynamic> json) =>
      json['groups'] != null ? GroupsModelRepository.fromJson(json['groups'] as Map<String, dynamic>) : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (groups != null) {
      data['groups'] = groups.toJson();
    }
    if (lactations != null) {
      data['lactations'] = lactations.toJson();
    }
    return data;
  }
}

class GroupsModelRepository {
  final List<GroupsDaysModelRepository> groupsDays;
  final List<GroupsHoursModelRepository> groupsHours;

  GroupsModelRepository(
    this.groupsDays,
    this.groupsHours,
  );

  GroupsModelRepository.fromJson(Map<String, dynamic> json)
      : groupsDays = _safeToListGroupsDays(json),
        groupsHours = _safeToListGroupsHours(json);

  static List<GroupsDaysModelRepository> _safeToListGroupsDays(Map<String, dynamic> json) {
    List<GroupsDaysModelRepository> _groupsDays;
    if (json['groups_days'] != null) {
      _groupsDays = [];
      try {
        json['groups_days']?.forEach((v) {
          _groupsDays.add(GroupsDaysModelRepository.fromJson(v as Map<String, dynamic>));
        });
      } catch (e) {
        print(e);
      }
    }
    return _groupsDays;
  }

  static List<GroupsHoursModelRepository> _safeToListGroupsHours(Map<String, dynamic> json) {
    List<GroupsHoursModelRepository> _groupsHours;
    if (json['groups_hours'] != null) {
      _groupsHours = [];
      try {
        json['groups_hours']?.forEach((v) {
          _groupsHours.add(GroupsHoursModelRepository.fromJson(v as Map<String, dynamic>));
        });
      } catch (e) {
        print(e);
      }
    }
    return _groupsHours;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (groupsDays != null) {
      data['groups_days'] = groupsDays.map((v) => v.toJson()).toList();
    }
    if (groupsHours != null) {
      data['groups_hours'] = groupsHours.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GroupsDaysModelRepository implements IGroupsModelRepository {
  final int day;

  @override
  final double g1;

  @override
  final double g2;

  @override
  final double g3;

  @override
  final double g4;

  @override
  final double g5;

  @override
  final double undefined;

  @override
  final double total;

  @override
  final double outside;

  GroupsDaysModelRepository(
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

  GroupsDaysModelRepository.fromJson(Map<String, dynamic> json)
      : day = json['day'] as int,
        g1 = _safeDouble(json['g1']),
        g2 = _safeDouble(json['g2']),
        g3 = _safeDouble(json['g3']),
        g4 = _safeDouble(json['g4']),
        g5 = _safeDouble(json['g5']),
        undefined = _safeDouble(json['undefined']),
        total = _safeDouble(json['total']),
        outside = _safeDouble(json['outside']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['day'] = day;
    data['g1'] = g1;
    data['g2'] = g2;
    data['g3'] = g3;
    data['g4'] = g4;
    data['g5'] = g5;
    data['undefined'] = undefined;
    data['total'] = total;
    data['outside'] = outside;
    return data;
  }
}

class GroupsHoursModelRepository implements IGroupsModelRepository {
  final int hour;

  @override
  final double g1;

  @override
  final double g2;

  @override
  final double g3;

  @override
  final double g4;

  @override
  final double g5;

  @override
  final double undefined;

  @override
  final double total;

  @override
  final double outside;

  GroupsHoursModelRepository(
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

  GroupsHoursModelRepository.fromJson(Map<String, dynamic> json)
      : hour = json['hour'] as int,
        g1 = _safeDouble(json['g1']),
        g2 = _safeDouble(json['g2']),
        g3 = _safeDouble(json['g3']),
        g4 = _safeDouble(json['g4']),
        g5 = _safeDouble(json['g5']),
        undefined = _safeDouble(json['undefined']),
        total = _safeDouble(json['total']),
        outside = _safeDouble(json['outside']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['hour'] = hour;
    data['g1'] = g1;
    data['g2'] = g2;
    data['g3'] = g3;
    data['g4'] = g4;
    data['g5'] = g5;
    data['undefined'] = undefined;
    data['total'] = total;
    data['outside'] = outside;
    return data;
  }
}

class LactationsModelRepository {
  final List<LactationsDaysModelRepository> lactationsDays;
  final List<LactationsHoursModelRepository> lactationsHours;

  LactationsModelRepository(
    this.lactationsDays,
    this.lactationsHours,
  );

  LactationsModelRepository.fromJson(Map<String, dynamic> json)
      : lactationsDays = _safeToListLactationsDays(json),
        lactationsHours = _safeToListLactationsHours(json);

  static List<LactationsDaysModelRepository> _safeToListLactationsDays(Map<String, dynamic> json) {
    List<LactationsDaysModelRepository> _lactationsDays;
    if (json['lactations_days'] != null) {
      _lactationsDays = [];
      try {
        json['lactations_days'].forEach((v) {
          _lactationsDays.add(LactationsDaysModelRepository.fromJson(v as Map<String, dynamic>));
        });
      } catch (e) {
        print(e);
      }
    }
    return _lactationsDays;
  }

  static List<LactationsHoursModelRepository> _safeToListLactationsHours(Map<String, dynamic> json) {
    List<LactationsHoursModelRepository> _lactationsHours;
    if (json['lactations_hours'] != null) {
      _lactationsHours = [];
      try {
        json['lactations_hours'].forEach((v) {
          _lactationsHours.add(LactationsHoursModelRepository.fromJson(v as Map<String, dynamic>));
        });
      } catch (e) {
        print(e);
      }
    }
    return _lactationsHours;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (lactationsDays != null) {
      data['lactations_days'] = lactationsDays.map((v) => v.toJson()).toList();
    }
    if (lactationsHours != null) {
      data['lactations_hours'] = lactationsHours.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LactationsDaysModelRepository implements ILactationsModelRepository {
  final int day;
  @override
  final double bred;

  @override
  final double dry;

  @override
  final double fresh;

  @override
  final double noBred;

  @override
  final double okOpen;

  @override
  final double preg;

  @override
  final double undefined;

  @override
  final double total;

  @override
  final double outside;

  LactationsDaysModelRepository(
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

  LactationsDaysModelRepository.fromJson(Map<String, dynamic> json)
      : day = json['day'] as int,
        bred = _safeDouble(json['bred']),
        dry = _safeDouble(json['dry']),
        fresh = _safeDouble(json['fresh']),
        noBred = _safeDouble(json['noBred']),
        okOpen = _safeDouble(json['okOpen']),
        preg = _safeDouble(json['preg']),
        undefined = _safeDouble(json['undefined']),
        total = _safeDouble(json['total']),
        outside = _safeDouble(json['outside']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['day'] = day;
    data['bred'] = bred;
    data['dry'] = dry;
    data['fresh'] = fresh;
    data['noBred'] = noBred;
    data['okOpen'] = okOpen;
    data['preg'] = preg;
    data['undefined'] = undefined;
    data['total'] = total;
    data['outside'] = outside;
    return data;
  }
}

class LactationsHoursModelRepository implements ILactationsModelRepository {
  final int hour;

  @override
  final double bred;

  @override
  final double dry;

  @override
  final double fresh;

  @override
  final double noBred;

  @override
  final double okOpen;

  @override
  final double preg;

  @override
  final double undefined;

  @override
  final double total;

  @override
  final double outside;

  LactationsHoursModelRepository(
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

  LactationsHoursModelRepository.fromJson(Map<String, dynamic> json)
      : hour = json['hour'] as int,
        bred = _safeDouble(json['bred']),
        dry = _safeDouble(json['dry']),
        fresh = _safeDouble(json['fresh']),
        noBred = _safeDouble(json['noBred']),
        okOpen = _safeDouble(json['okOpen']),
        preg = _safeDouble(json['preg']),
        undefined = _safeDouble(json['undefined']),
        total = _safeDouble(json['total']),
        outside = _safeDouble(json['outside']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['hour'] = hour;
    data['bred'] = bred;
    data['dry'] = dry;
    data['fresh'] = fresh;
    data['noBred'] = noBred;
    data['okOpen'] = okOpen;
    data['preg'] = preg;
    data['undefined'] = undefined;
    data['total'] = total;
    data['outside'] = outside;
    return data;
  }
}

class TemperatureModelRepository {
  final GroupsModelRepository groups;
  final LactationsModelRepository lactations;

  TemperatureModelRepository(
    this.groups,
    this.lactations,
  );

  TemperatureModelRepository.fromJson(Map<String, dynamic> json)
      : groups = _safeGroups(json),
        lactations = _safeLactations(json);

  static GroupsModelRepository _safeGroups(Map<String, dynamic> json) {
    return json['groups'] != null ? GroupsModelRepository.fromJson(json['groups'] as Map<String, dynamic>) : null;
  }

  static LactationsModelRepository _safeLactations(Map<String, dynamic> json) {
    return json['lactations'] != null
        ? LactationsModelRepository.fromJson(json['lactations'] as Map<String, dynamic>)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (groups != null) {
      data['groups'] = groups.toJson();
    }
    if (lactations != null) {
      data['lactations'] = lactations.toJson();
    }
    return data;
  }
}

double _safeDouble(dynamic d) {
  try {
    return ((d as num) ?? 0.0).toDouble();
  } catch (e) {
    return null;
  }
}
