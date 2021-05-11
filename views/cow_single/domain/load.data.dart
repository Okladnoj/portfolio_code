import '../models/cow_single_ui.dart';
import '../models/temperature_chart.dart';
import '../models/water_chart.dart';

import 'functions/function.dart';
import 'functions/load_alerts_data.dart';

Future<CowSingleModelUI> loadDataOfAlerts(CowSingleModelUI cowSingleModel) async {
  final bolusId = cowSingleModel.bolusId;
  final alertsModel = await getAlertsData(bolusId);

  return cowSingleModel.copy(alertsModel: alertsModel);
}

Future<CowSingleModelUI> loadDataOfDay(int animalId, int bolusId) async {
  Map<String, double> temperatureMaxMin;
  final info = await getInfo(bolusId);
  final Map<StateTimeInterval, String> waterIntakesData = {};
  waterIntakesData[StateTimeInterval.today] = await getWaterIntakeData('today', bolusId);

  final _temperatureChartOfDay = await getTemperatureChartData('today', bolusId);
  temperatureMaxMin = getMaxMin(_temperatureChartOfDay['temperatureChart'] as List<double>);
  final temperatureChartOfDay = TemperatureChart(
    minTemperature: temperatureMaxMin['minTemperature'],
    maxTemperature: temperatureMaxMin['maxTemperature'],
    temperatureChartTitleDate: _temperatureChartOfDay['temperatureChartTitleDate'] as String,
    temperatureChartLabels: _temperatureChartOfDay['temperatureChartLabels'] as List<String>,
    temperatureChart: _temperatureChartOfDay['temperatureChart'] as List<double>,
  );

  final _waterChartModelOfDay = await getIntakeChartData('today', bolusId);
  final waterChartModelOfDay = WaterChartModel(
    waterChartTitleDate: _waterChartModelOfDay['waterChartTitleDate'] as String,
    waterChartLabels: _waterChartModelOfDay['waterChartLabels'] as List<String>,
    waterChart: _waterChartModelOfDay['waterChart'] as List<double>,
    waterChartNormal: _waterChartModelOfDay['waterChartNormal'] as List<double>,
  );

  final CowSingleModelUI cowSingleModelUI = CowSingleModelUI(
    animalId: animalId,
    bolusId: bolusId,
    lactationStage: info['lactationStage'],
    daysInMilk: info['daysInMilk'],
    currentLactation: info['currentLactation'],
    due: info['due'],
    waterIntakesData: waterIntakesData,
    selectedFilter: StateTimeInterval.today,
    alertsModel: null,
    temperatureChartOfDay: temperatureChartOfDay,
    temperatureChartOfWeek: null,
    waterChartModelOfDay: waterChartModelOfDay,
    waterChartModelOfWeek: null,
  );

  return cowSingleModelUI;
}

Future<CowSingleModelUI> loadDataOfWeek(CowSingleModelUI cowSingleModel) async {
  final int animalId = cowSingleModel.animalId;
  final int bolusId = cowSingleModel.bolusId;
  Map<String, double> temperatureMaxMin;

  final _temperatureChartOfWeek = await getTemperatureChartData('week', bolusId);
  temperatureMaxMin = getMaxMin(_temperatureChartOfWeek['temperatureChart'] as List<double>);
  final temperatureChartOfWeek = TemperatureChart(
    minTemperature: temperatureMaxMin['minTemperature'],
    maxTemperature: temperatureMaxMin['maxTemperature'],
    temperatureChartTitleDate: _temperatureChartOfWeek['temperatureChartTitleDate'] as String,
    temperatureChartLabels: _temperatureChartOfWeek['temperatureChartLabels'] as List<String>,
    temperatureChart: _temperatureChartOfWeek['temperatureChart'] as List<double>,
  );

  final _waterChartModelOfWeek = await getIntakeChartData('week', bolusId);
  final waterChartModelOfWeek = WaterChartModel(
    waterChartTitleDate: _waterChartModelOfWeek['waterChartTitleDate'] as String,
    waterChartLabels: _waterChartModelOfWeek['waterChartLabels'] as List<String>,
    waterChart: _waterChartModelOfWeek['waterChart'] as List<double>,
    waterChartNormal: _waterChartModelOfWeek['waterChartNormal'] as List<double>,
  );

  final CowSingleModelUI cowSingleModelUI = cowSingleModel.copy(
    animalId: animalId,
    bolusId: bolusId,
    selectedFilter: StateTimeInterval.today,
    temperatureChartOfWeek: temperatureChartOfWeek,
    waterChartModelOfWeek: waterChartModelOfWeek,
  );

  return cowSingleModelUI;
}

Future<CowSingleModelUI> loadDataOfDayAndWeek(int animalId, int bolusId) async {
  Map<String, double> temperatureMaxMin;
  final info = await getInfo(bolusId);
  final Map<StateTimeInterval, String> waterIntakesData = {};
  waterIntakesData[StateTimeInterval.today] = await getWaterIntakeData('today', bolusId);
  waterIntakesData[StateTimeInterval.week] = await getWaterIntakeData('week', bolusId);

  final _temperatureChartOfDay = await getTemperatureChartData('today', bolusId);
  temperatureMaxMin = getMaxMin(_temperatureChartOfDay['temperatureChart'] as List<double>);
  final temperatureChartOfDay = TemperatureChart(
    minTemperature: temperatureMaxMin['minTemperature'],
    maxTemperature: temperatureMaxMin['maxTemperature'],
    temperatureChartTitleDate: _temperatureChartOfDay['temperatureChartTitleDate'] as String,
    temperatureChartLabels: _temperatureChartOfDay['temperatureChartLabels'] as List<String>,
    temperatureChart: _temperatureChartOfDay['temperatureChart'] as List<double>,
  );

  final _temperatureChartOfWeek = await getTemperatureChartData('week', bolusId);
  temperatureMaxMin = getMaxMin(_temperatureChartOfWeek['temperatureChart'] as List<double>);
  final temperatureChartOfWeek = TemperatureChart(
    minTemperature: temperatureMaxMin['minTemperature'],
    maxTemperature: temperatureMaxMin['maxTemperature'],
    temperatureChartTitleDate: _temperatureChartOfWeek['temperatureChartTitleDate'] as String,
    temperatureChartLabels: _temperatureChartOfWeek['temperatureChartLabels'] as List<String>,
    temperatureChart: _temperatureChartOfWeek['temperatureChart'] as List<double>,
  );

  final _waterChartModelOfDay = await getIntakeChartData('today', bolusId);
  final waterChartModelOfDay = WaterChartModel(
    waterChartTitleDate: _waterChartModelOfDay['waterChartTitleDate'] as String,
    waterChartLabels: _waterChartModelOfDay['waterChartLabels'] as List<String>,
    waterChart: _waterChartModelOfDay['waterChart'] as List<double>,
    waterChartNormal: _waterChartModelOfDay['waterChartNormal'] as List<double>,
  );

  final _waterChartModelOfWeek = await getIntakeChartData('week', bolusId);
  final waterChartModelOfWeek = WaterChartModel(
    waterChartTitleDate: _waterChartModelOfWeek['waterChartTitleDate'] as String,
    waterChartLabels: _waterChartModelOfWeek['waterChartLabels'] as List<String>,
    waterChart: _waterChartModelOfWeek['waterChart'] as List<double>,
    waterChartNormal: _waterChartModelOfWeek['waterChartNormal'] as List<double>,
  );

  final alertsModel = await getAlertsData(bolusId);

  final CowSingleModelUI cowSingleModelUI = CowSingleModelUI(
    animalId: animalId,
    bolusId: bolusId,
    lactationStage: info['lactationStage'],
    daysInMilk: info['daysInMilk'],
    currentLactation: info['currentLactation'],
    due: info['due'],
    waterIntakesData: waterIntakesData,
    selectedFilter: StateTimeInterval.today,
    alertsModel: alertsModel,
    temperatureChartOfDay: temperatureChartOfDay,
    temperatureChartOfWeek: temperatureChartOfWeek,
    waterChartModelOfDay: waterChartModelOfDay,
    waterChartModelOfWeek: waterChartModelOfWeek,
  );

  return cowSingleModelUI;
}
