import 'package:cattle_scan/api/api.dart';
import 'package:intl/intl.dart';

import 'help_functions.dart';

Future<Map<String, dynamic>> getTemperatureChartData(String period, int bolusId) async {
  final f = DateFormat('yyyy-MM-dd HH:mm');
  final Map<String, dynamic> temperatureChartData = {};
  String _temperatureChartTitleDate;
  List<String> _temperatureChartLabels;
  List<double> _temperatureChart;

  List<dynamic> postData;

  final DateTime currentDate = DateTime.now();

  if (period == 'today') {
    final DateTime todayDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      currentDate.hour,
      currentDate.minute,
      currentDate.second,
    );

    final DateTime yesterdayDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day - 1,
      currentDate.hour,
      currentDate.minute,
      currentDate.second,
    );

    postData = [
      bolusId,
      f.format(yesterdayDate),
      f.format(todayDate),
    ];
  } else {
    // Week
    final DateTime weekDate = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day - 7,
      currentDate.hour,
      currentDate.minute,
      currentDate.second,
    ).toUtc();

    postData = [
      bolusId,
      f.format(weekDate),
      f.format(currentDate),
    ];
  }

  try {
    final responseData = await CallApi.parsData('getDataForChart', postData);

    if (responseData != null) {
      final List<String> chartLabels = [];
      final List<double> chart = [];
      String titleDate;

      const mapNameOfTemperature = 'temperature';
      const mapNameOfDateTime = 'bolus_full_date';

      if (period == 'today') {
        responseData['data'].forEach((element) {
          final List<String> titleDateTime = (element[mapNameOfDateTime] as String).split(' ');
          titleDate = titleDateTime[0];

          chartLabels.add(
            '${titleDateTime[1].split(':')[0]}:${titleDateTime[1].split(':')[1]}',
          );

          chart.add(safeDouble(element[mapNameOfTemperature]));
        });

        _temperatureChartTitleDate = titleDate;
        _temperatureChartLabels = chartLabels;
        _temperatureChart = chart;
      } else {
        // Temperature for week
        titleDate = '${responseData['data'][0][mapNameOfDateTime].split(' ')[0]}' +
            ' - ${responseData['data'].last[mapNameOfDateTime].split(' ')[0]}';

        responseData['data'].forEach((element) {
          final List<String> titleDateTime = (element[mapNameOfDateTime] as String).split(' ');

          chartLabels.add(
            '${titleDateTime[0]} ${titleDateTime[1].split(':')[0]}:${titleDateTime[1].split(':')[1]}',
          );

          chart.add(safeDouble(element[mapNameOfTemperature]));
        });

        _temperatureChartTitleDate = titleDate;
        _temperatureChartLabels = chartLabels;
        _temperatureChart = chart;
      }

      temperatureChartData['temperatureChartTitleDate'] = _temperatureChartTitleDate;
      temperatureChartData['temperatureChartLabels'] = _temperatureChartLabels;
      temperatureChartData['temperatureChart'] = _temperatureChart;
    }
  } catch (e) {
    print(e);
  }

  return temperatureChartData;
}
