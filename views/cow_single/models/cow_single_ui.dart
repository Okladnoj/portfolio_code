import 'package:cattle_scan/views/alerts/models/alert_model.dart';
import 'package:flutter/cupertino.dart';

import 'temperature_chart.dart';
import 'water_chart.dart';

enum StateTimeInterval {
  today,
  week,
}

class CowSingleModelUI {
  final int animalId;
  final int bolusId;

  final String lactationStage;
  final String daysInMilk;
  final String currentLactation;
  final String due;
  final Map<StateTimeInterval, String> waterIntakesData;

  StateTimeInterval selectedFilter;

  /// Pagination for alerts for this cow

  final AlertsModel alertsModel;

  /// Temperature chart
  final TemperatureChart temperatureChartOfDay;
  final TemperatureChart temperatureChartOfWeek;

  /// Water chart
  WaterChartModel waterChartModelOfDay;
  WaterChartModel waterChartModelOfWeek;

  CowSingleModelUI({
    @required this.animalId,
    @required this.bolusId,
    @required this.lactationStage,
    @required this.daysInMilk,
    @required this.currentLactation,
    @required this.waterIntakesData,
    @required this.selectedFilter,
    @required this.alertsModel,
    @required this.temperatureChartOfDay,
    @required this.temperatureChartOfWeek,
    @required this.waterChartModelOfDay,
    @required this.waterChartModelOfWeek,
    @required this.due,
  });

  CowSingleModelUI copy({
    int animalId,
    int bolusId,
    String lactationStage,
    String daysInMilk,
    String currentLactation,
    String due,
    Map<StateTimeInterval, String> waterIntakesData,
    StateTimeInterval selectedFilter,
    AlertsModel alertsModel,
    int currentPage,
    int maxPage,
    bool gotAllAlerts,
    bool gettingMoreAlerts,
    TemperatureChart temperatureChartOfDay,
    TemperatureChart temperatureChartOfWeek,
    WaterChartModel waterChartModelOfDay,
    WaterChartModel waterChartModelOfWeek,
  }) {
    return CowSingleModelUI(
      animalId: animalId ?? this.animalId,
      bolusId: bolusId ?? this.bolusId,
      lactationStage: lactationStage ?? this.lactationStage,
      daysInMilk: daysInMilk ?? this.daysInMilk,
      currentLactation: currentLactation ?? this.currentLactation,
      due: due ?? this.due,
      waterIntakesData: waterIntakesData ?? this.waterIntakesData,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      alertsModel: alertsModel ?? this.alertsModel,
      temperatureChartOfDay: temperatureChartOfDay ?? this.temperatureChartOfDay,
      temperatureChartOfWeek: temperatureChartOfWeek ?? this.temperatureChartOfWeek,
      waterChartModelOfDay: waterChartModelOfDay ?? this.waterChartModelOfDay,
      waterChartModelOfWeek: waterChartModelOfWeek ?? this.waterChartModelOfWeek,
    );
  }
}
