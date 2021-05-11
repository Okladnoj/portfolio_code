import 'package:flutter/cupertino.dart';

class WaterChartModel {
  final String waterChartTitleDate;

  final List<String> waterChartLabels;
  final List<double> waterChart;
  final List<double> waterChartNormal;

  WaterChartModel({
    @required this.waterChartTitleDate,
    @required this.waterChartLabels,
    @required this.waterChart,
    @required this.waterChartNormal,
  });
}
