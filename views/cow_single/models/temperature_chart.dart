import 'package:flutter/cupertino.dart';

class TemperatureChart {
  final String temperatureChartTitleDate;
  final double minTemperature;
  final double maxTemperature;

  final List<String> temperatureChartLabels;
  final List<double> temperatureChart;

  TemperatureChart({
    @required this.temperatureChartTitleDate,
    @required this.minTemperature,
    @required this.maxTemperature,
    @required this.temperatureChartLabels,
    @required this.temperatureChart,
  });
}
