import 'package:cattle_scan/api/api.dart';
import 'package:intl/intl.dart';

import 'help_functions.dart';

Future<Map<String, dynamic>> getIntakeChartData(String period, int bolusId) async {
  final f = DateFormat('yyyy-MM-dd HH:mm');
  final Map<String, dynamic> intakeChartData = {};
  List<dynamic> postData;

  String _waterChartTitleDate;
  List<String> _waterChartLabels;
  List<double> _waterChart;
  List<double> _waterChartNormal;

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
    );

    postData = [
      bolusId,
      f.format(weekDate),
      f.format(currentDate),
    ];
  }

  try {
    final responseData = await CallApi.parsData('getIntakesData', postData);

    if (responseData != null) {
      final List<String> chartLabels = [];
      final List<double> chart = [];
      final List<double> chartNormal = [];
      String titleDate;

      const mapNameOfWater = 'value';
      const mapNameOfDateTime = 'arg';

      if (period == 'today') {
        responseData['data'].forEach((element) {
          final List<String> titleDateTime = (element[mapNameOfDateTime] as String).split(' ');
          titleDate = titleDateTime[0];

          chartLabels.add(
            '${titleDateTime[1].split(':')[0]}:${titleDateTime[1].split(':')[1]}',
          );

          chart.add(safeDouble(element[mapNameOfWater]));
          chartNormal.add(null);
        });

        _waterChartTitleDate = titleDate;
        _waterChartLabels = chartLabels;
        _waterChart = chart;
      } else {
        // Water intake for week
        try {
          titleDate =
              '${responseData['data'][0][mapNameOfDateTime].split(' ')[0]} - ${responseData['data'].last[mapNameOfDateTime].split(' ')[0]}';
        } catch (e) {
          print(e);
        }

        responseData['data'].forEach((element) {
          final List<String> titleDateTime = (element[mapNameOfDateTime] as String).split(' ');

          chartLabels.add(
            '${titleDateTime[0]} ${titleDateTime[1].split(':')[0]}:${titleDateTime[1].split(':')[1]}',
          );

          chart.add(safeDouble(element[mapNameOfWater]));
        });

        _waterChartTitleDate = titleDate;
        _waterChartLabels = chartLabels;
        _waterChart = chart;
        _waterChartNormal = _getNormal(chartLabels, chart);
      }

      intakeChartData['waterChartTitleDate'] = _waterChartTitleDate;
      intakeChartData['waterChartLabels'] = _waterChartLabels;
      intakeChartData['waterChart'] = _waterChart;
      intakeChartData['waterChartNormal'] = _waterChartNormal;
    }
  } catch (e) {
    print('In function "getIntakeChartData": $e');
  }

  return intakeChartData;
}

List<double> _getNormal(List<String> labels, List<double> series) {
  final List<double> chartNormal = [];
  final _f = DateFormat('yyyy-MM-dd HH:mm');
  DateTime dateMemory = _f.parse(labels?.first);
  List<double> seriesNormal = [];
  for (var i = 0; i < series.length; i++) {
    final date = _f.parse(labels[i]);
    if (dateMemory?.day == date?.day) {
      seriesNormal.add(series[i]);
    } else {
      double sum = 0;
      seriesNormal.forEach((e) {
        sum += e ?? 0;
      });
      final double normal = sum / seriesNormal.length;
      seriesNormal.forEach((e) {
        chartNormal.add(sum);
      });
      dateMemory = date;
      seriesNormal = [];
      seriesNormal.add(series[i]);
    }
  }

  double sum = 0;
  seriesNormal.forEach((e) {
    sum += e ?? 0;
  });
  final double normal = sum / seriesNormal.length;
  seriesNormal.forEach((e) {
    chartNormal.add(sum);
  });
  seriesNormal = [];

  return chartNormal;
}
