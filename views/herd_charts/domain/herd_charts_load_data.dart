import 'dart:convert';

import 'package:cattle_scan/api/api.dart';
import 'package:cattle_scan/views/herd_charts/models/interface/interface.dart';
import 'package:intl/intl.dart';

import '../models/herd_charts_model.dart';
import '../models/herd_charts_model_repository.dart';

class HerdChartsService {
  final f = DateFormat('M-yyyy');

  Map<String, dynamic> defaultData = {};

  Map<String, dynamic> temperatureGroupDay;
  Map<String, dynamic> temperatureGroupHour;
  Map<String, dynamic> temperatureLactationsDay;
  Map<String, dynamic> temperatureLactationsHour;
  Map<String, dynamic> waterGroupDay;
  Map<String, dynamic> waterGroupHour;
  Map<String, dynamic> waterLactationsDay;
  Map<String, dynamic> waterLactationsHour;

  dynamic get temperatureChart => {
        "groups": {
          "groups_days": temperatureGroupDay?.values?.first ?? defaultData,
          "groups_hours": temperatureGroupHour?.values?.first ?? defaultData,
        },
        "lactations": {
          "lactations_days": temperatureLactationsDay?.values?.first ?? defaultData,
          "lactations_hours": temperatureLactationsHour?.values?.first ?? defaultData,
        },
      };

  dynamic get waterChart => {
        "groups": {
          "groups_days": waterGroupDay?.values?.first ?? defaultData,
          "groups_hours": waterGroupHour?.values?.first ?? defaultData,
        },
        "lactations": {
          "lactations_days": waterLactationsDay?.values?.first ?? defaultData,
          "lactations_hours": waterLactationsHour?.values?.first ?? defaultData,
        },
      };

//====================================================================< [Temperature]
  Future<TemperatureModel> loadTemperatureGroupDay(DateTime date) async {
    final dynamic postData = [
      'month',
      f.format(date),
      'farm',
      'group',
    ];

    final responseData = await CallApi.parsData('tmbyday', postData);
    if (responseData != null) {
      temperatureGroupDay = jsonDecode(responseData['data'] as String) as Map<String, dynamic>;
    } else {}

    return _loadTemperatureModel(date);
  }

  Future<TemperatureModel> loadTemperatureGroupHour(DateTime date) async {
    final dynamic postData = [
      'month',
      f.format(date),
      'farm',
      'group',
    ];

    final responseData = await CallApi.parsData('tmbyhour', postData);
    if (responseData != null) {
      temperatureGroupHour = jsonDecode(responseData['data'] as String) as Map<String, dynamic>;
    } else {}

    return _loadTemperatureModel(date);
  }

  Future<TemperatureModel> loadTemperatureLactationsDay(DateTime date) async {
    final dynamic postData = [
      'month',
      f.format(date),
      'farm',
    ];

    final responseData = await CallApi.parsData('tmbyday', postData);
    if (responseData != null) {
      temperatureLactationsDay = jsonDecode(responseData['data'] as String) as Map<String, dynamic>;
    } else {}

    return _loadTemperatureModel(date);
  }

  Future<TemperatureModel> loadTemperatureLactationsHour(DateTime date) async {
    final dynamic postData = [
      'month',
      f.format(date),
      'farm',
    ];

    final responseData = await CallApi.parsData('tmbyhour', postData);
    if (responseData != null) {
      temperatureLactationsHour = jsonDecode(responseData['data'] as String) as Map<String, dynamic>;
    } else {}

    return _loadTemperatureModel(date);
  }

//====================================================================< [Water]
  Future<WaterModel> loadWaterGroupDay(DateTime date) async {
    final dynamic postData = [
      'month',
      f.format(date),
      'water',
      'group',
    ];

    final responseData = await CallApi.parsData('tmbyday', postData);
    if (responseData != null) {
      waterGroupDay = jsonDecode(responseData['data'] as String) as Map<String, dynamic>;
    } else {}

    return _loadWaterModel(date);
  }

  Future<WaterModel> loadWaterGroupHour(DateTime date) async {
    final dynamic postData = [
      'month',
      f.format(date),
      'water',
      'group',
    ];

    final responseData = await CallApi.parsData('tmbyhour', postData);
    if (responseData != null) {
      waterGroupHour = jsonDecode(responseData['data'] as String) as Map<String, dynamic>;
    } else {}

    return _loadWaterModel(date);
  }

  Future<WaterModel> loadWaterLactationsDay(DateTime date) async {
    final dynamic postData = [
      'month',
      f.format(date),
      'water',
    ];

    final responseData = await CallApi.parsData('tmbyday', postData);
    if (responseData != null) {
      waterLactationsDay = jsonDecode(responseData['data'] as String) as Map<String, dynamic>;
    } else {}

    return _loadWaterModel(date);
  }

  Future<WaterModel> loadWaterLactationsHour(DateTime date) async {
    final dynamic postData = [
      'month',
      f.format(date),
      'water',
    ];

    final responseData = await CallApi.parsData('tmbyhour', postData);
    if (responseData != null) {
      waterLactationsHour = jsonDecode(responseData['data'] as String) as Map<String, dynamic>;
    } else {}

    return _loadWaterModel(date);
  }

//====================================================================< [loaders]
  Future<WaterModel> _loadWaterModel(DateTime date) async {
    final r = WaterModelRepository.fromJson(_fixJson(waterChart) as Map<String, dynamic>);
    final _waterModel = WaterModel(
      TimeInterval.day,
      SubGroupOfCharts.lactations,
      _mapToGroupsModel(r?.groups),
      _mapToLactationsModel(r?.lactations),
      date,
      true,
    );
    return _waterModel;
  }

  Future<TemperatureModel> _loadTemperatureModel(DateTime date) async {
    final r = WaterModelRepository.fromJson(_fixJson(temperatureChart) as Map<String, dynamic>);
    final _temperatureModel = TemperatureModel(
      TimeInterval.day,
      SubGroupOfCharts.lactations,
      _mapToGroupsModel(r?.groups),
      _mapToLactationsModel(r?.lactations),
      date,
      true,
    );

    return _temperatureModel;
  }

  GroupsModel _mapToGroupsModel(GroupsModelRepository groups) {
    return GroupsModel(
      _mapToListGroupsDaysModel(groups?.groupsDays),
      _mapToListGroupsHoursModel(groups?.groupsHours),
    );
  }

  GroupsDaysModel _mapToListGroupsDaysModel(List<GroupsDaysModelRepository> groupsDays) {
    final data = _generateDataGraphicsGroup(groupsDays);
    return GroupsDaysModel(
      groupsDays?.map((e) => e.day)?.toList() ?? [],
      data[0],
      data[1],
      data[2],
      data[3],
      data[4],
      data[5],
      data[6],
      data[7],
    );
  }

  GroupsHoursModel _mapToListGroupsHoursModel(List<GroupsHoursModelRepository> groupsHours) {
    final data = _generateDataGraphicsGroup(groupsHours);
    return GroupsHoursModel(
      groupsHours?.map((e) => e.hour)?.toList() ?? [],
      data[0],
      data[1],
      data[2],
      data[3],
      data[4],
      data[5],
      data[6],
      data[7],
    );
  }

  LactationsModel _mapToLactationsModel(LactationsModelRepository lactations) {
    return LactationsModel(
      _mapToListLactationsDaysModel(lactations?.lactationsDays),
      _mapToListLactationsHoursModel(lactations?.lactationsHours),
    );
  }

  List<ActionLineOfLactations> _mapToListActionLineOfLactations() {
    return [ActionLineOfLactations.total, ActionLineOfLactations.outside];
  }

  LactationsDaysModel _mapToListLactationsDaysModel(List<LactationsDaysModelRepository> lactationsDays) {
    final data = _generateDataGraphicsLactations(lactationsDays);
    return LactationsDaysModel(
      lactationsDays?.map((e) => e.day)?.toList() ?? [],
      data[0],
      data[1],
      data[2],
      data[3],
      data[4],
      data[5],
      data[6],
      data[7],
      data[8],
    );
  }

  LactationsHoursModel _mapToListLactationsHoursModel(List<LactationsHoursModelRepository> lactationsHours) {
    final data = _generateDataGraphicsLactations(lactationsHours);
    return LactationsHoursModel(
      lactationsHours?.map((e) => e.hour)?.toList() ?? [],
      data[0],
      data[1],
      data[2],
      data[3],
      data[4],
      data[5],
      data[6],
      data[7],
      data[8],
    );
  }

  List<GraphicModel> _generateDataGraphicsGroup(List<IGroupsModelRepository> groups) {
    final g1 = GraphicModel(
      'G1',
      groups?.map((e) => _fixValue(e.g1))?.toList() ?? [],
      'line',
      ColorsCollection.groupsSet[ActionLineOfGroups.g1],
      false,
    );
    final g2 = GraphicModel(
      'G2',
      groups?.map((e) => _fixValue(e.g2))?.toList() ?? [],
      'line',
      ColorsCollection.groupsSet[ActionLineOfGroups.g2],
      false,
    );
    final g3 = GraphicModel(
      'G3',
      groups?.map((e) => _fixValue(e.g3))?.toList() ?? [],
      'line',
      ColorsCollection.groupsSet[ActionLineOfGroups.g3],
      false,
    );
    final g4 = GraphicModel(
      'G4',
      groups?.map((e) => _fixValue(e.g4))?.toList() ?? [],
      'line',
      ColorsCollection.groupsSet[ActionLineOfGroups.g4],
      false,
    );
    final g5 = GraphicModel(
      'G5',
      groups?.map((e) => _fixValue(e.g5))?.toList() ?? [],
      'line',
      ColorsCollection.groupsSet[ActionLineOfGroups.g5],
      false,
    );
    final undefined = GraphicModel(
      'UNDEFINED',
      groups?.map((e) => _fixValue(e.undefined))?.toList() ?? [],
      'line',
      ColorsCollection.groupsSet[ActionLineOfGroups.undefined],
      false,
    );
    final total = GraphicModel(
      'TOTAL',
      groups?.map((e) => _fixValue(e.total))?.toList() ?? [],
      'line',
      ColorsCollection.groupsSet[ActionLineOfGroups.total],
      true,
    );
    final outside = GraphicModel(
      'OUTSIDE',
      groups?.map((e) => _fixValue(e.outside))?.toList() ?? [],
      'line',
      ColorsCollection.groupsSet[ActionLineOfGroups.outside],
      false,
    );
    return [g1, g2, g3, g4, g5, undefined, total, outside];
  }

  List<GraphicModel> _generateDataGraphicsLactations(List<ILactationsModelRepository> lactations) {
    final bred = GraphicModel(
      'BRED',
      lactations?.map((e) => _fixValue(e.bred))?.toList() ?? [],
      'line',
      ColorsCollection.lactationsSet[ActionLineOfLactations.bred],
      false,
    );
    final dry = GraphicModel(
      'DRY',
      lactations?.map((e) => _fixValue(e.dry))?.toList() ?? [],
      'line',
      ColorsCollection.lactationsSet[ActionLineOfLactations.dry],
      false,
    );
    final fresh = GraphicModel(
      'FRESH',
      lactations?.map((e) => _fixValue(e.fresh))?.toList() ?? [],
      'line',
      ColorsCollection.lactationsSet[ActionLineOfLactations.fresh],
      false,
    );
    final noBred = GraphicModel(
      'NOBRED',
      lactations?.map((e) => _fixValue(e.noBred))?.toList() ?? [],
      'line',
      ColorsCollection.lactationsSet[ActionLineOfLactations.noBred],
      false,
    );
    final okOpen = GraphicModel(
      'OK/OPEN',
      lactations?.map((e) => _fixValue(e.okOpen))?.toList() ?? [],
      'line',
      ColorsCollection.lactationsSet[ActionLineOfLactations.okOpen],
      false,
    );
    final preg = GraphicModel(
      'PREG',
      lactations?.map((e) => _fixValue(e.preg))?.toList() ?? [],
      'line',
      ColorsCollection.lactationsSet[ActionLineOfLactations.preg],
      false,
    );
    final undefined = GraphicModel(
      'UNDEFINED',
      lactations?.map((e) => _fixValue(e.undefined))?.toList() ?? [],
      'line',
      ColorsCollection.lactationsSet[ActionLineOfLactations.undefined],
      false,
    );
    final total = GraphicModel(
      'TOTAL',
      lactations?.map((e) => _fixValue(e.total))?.toList() ?? [],
      'line',
      ColorsCollection.lactationsSet[ActionLineOfLactations.total],
      true,
    );
    final outside = GraphicModel(
      'OUTSIDE',
      lactations?.map((e) => _fixValue(e.outside))?.toList() ?? [],
      'line',
      ColorsCollection.lactationsSet[ActionLineOfLactations.outside],
      false,
    );
    return [bred, dry, fresh, noBred, okOpen, preg, undefined, total, outside];
  }
}

dynamic _fixJson(dynamic d) {
  return jsonDecode(jsonEncode(d));
}

double _fixValue(double d) {
  if (d == 0) {
    return null;
  } else {
    return d;
  }
}
