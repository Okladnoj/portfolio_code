import 'dart:convert';

import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/cow_single/domain/functions/function.dart';
import 'package:cattle_scan/views/herd_charts/models/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

import '../models/herd_charts_model_ui.dart';

class ChartCardOfTemperature extends StatelessWidget {
  const ChartCardOfTemperature({
    Key key,
    this.herdChartsModelUI,
  }) : super(key: key);

  final HerdChartsModelUI herdChartsModelUI;

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      height: isPortrait ? 300 : 400,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: DesignStile.buttonDecoration(
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
      child: LayoutBuilder(builder: (context, boxConstraints) {
        final isLoad = herdChartsModelUI?.temperature?.isLoad ?? false;
        if (!isLoad) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
            ),
          );
        }
        final orientation = MediaQuery.of(context).orientation;
        return Echarts(
          key: ValueKey(orientation),
          captureHorizontalGestures: true,
          option: getOption(),
        );
      }),
    );
  }

  String getOption() {
    final isLactation = herdChartsModelUI?.temperature?.subGroup == SubGroupOfCharts.lactations;
    final isDay = herdChartsModelUI?.temperature?.timeInterval == TimeInterval.day;

    List<GraphicModelUI> currentGraphics;
    GraphicModelUI outside;

    final List<String> legend = [];
    final List<Map<String, dynamic>> series = [];
    final List<Map<String, dynamic>> series2 = [];
    final List<double> data = [];
    final List<double> data2 = [];
    List<int> xAxisData = [];

    if (isLactation) {
      if (isDay) {
        xAxisData = herdChartsModelUI?.temperature?.lactations?.lactationsDays?.day;
        outside = herdChartsModelUI?.temperature?.lactations?.lactationsDays?.outside;
        currentGraphics = [
          herdChartsModelUI?.temperature?.lactations?.lactationsDays?.bred,
          herdChartsModelUI?.temperature?.lactations?.lactationsDays?.dry,
          herdChartsModelUI?.temperature?.lactations?.lactationsDays?.fresh,
          herdChartsModelUI?.temperature?.lactations?.lactationsDays?.noBred,
          herdChartsModelUI?.temperature?.lactations?.lactationsDays?.okOpen,
          herdChartsModelUI?.temperature?.lactations?.lactationsDays?.preg,
          herdChartsModelUI?.temperature?.lactations?.lactationsDays?.undefined,
          herdChartsModelUI?.temperature?.lactations?.lactationsDays?.total,
        ];
      } else {
        xAxisData = herdChartsModelUI?.temperature?.lactations?.lactationsHours?.hour;
        outside = herdChartsModelUI?.temperature?.lactations?.lactationsHours?.outside;
        currentGraphics = [
          herdChartsModelUI?.temperature?.lactations?.lactationsHours?.bred,
          herdChartsModelUI?.temperature?.lactations?.lactationsHours?.dry,
          herdChartsModelUI?.temperature?.lactations?.lactationsHours?.fresh,
          herdChartsModelUI?.temperature?.lactations?.lactationsHours?.noBred,
          herdChartsModelUI?.temperature?.lactations?.lactationsHours?.okOpen,
          herdChartsModelUI?.temperature?.lactations?.lactationsHours?.preg,
          herdChartsModelUI?.temperature?.lactations?.lactationsHours?.undefined,
          herdChartsModelUI?.temperature?.lactations?.lactationsHours?.total,
        ];
      }
    } else {
      if (isDay) {
        xAxisData = herdChartsModelUI?.temperature?.groups?.groupsDays?.day;
        outside = herdChartsModelUI?.temperature?.groups?.groupsDays?.outside;
        currentGraphics = [
          herdChartsModelUI?.temperature?.groups?.groupsDays?.g1,
          herdChartsModelUI?.temperature?.groups?.groupsDays?.g2,
          herdChartsModelUI?.temperature?.groups?.groupsDays?.g3,
          herdChartsModelUI?.temperature?.groups?.groupsDays?.g4,
          herdChartsModelUI?.temperature?.groups?.groupsDays?.g5,
          herdChartsModelUI?.temperature?.groups?.groupsDays?.undefined,
          herdChartsModelUI?.temperature?.groups?.groupsDays?.total,
        ];
      } else {
        xAxisData = herdChartsModelUI?.temperature?.groups?.groupsHours?.hour;
        outside = herdChartsModelUI?.temperature?.groups?.groupsHours?.outside;
        currentGraphics = [
          herdChartsModelUI?.temperature?.groups?.groupsHours?.g1,
          herdChartsModelUI?.temperature?.groups?.groupsHours?.g2,
          herdChartsModelUI?.temperature?.groups?.groupsHours?.g3,
          herdChartsModelUI?.temperature?.groups?.groupsHours?.g4,
          herdChartsModelUI?.temperature?.groups?.groupsHours?.g5,
          herdChartsModelUI?.temperature?.groups?.groupsHours?.undefined,
          herdChartsModelUI?.temperature?.groups?.groupsHours?.total,
        ];
      }
    }

    for (final g in currentGraphics) {
      if (g?.isShow ?? false) {
        series.add({
          'name': g.name,
          //areaStyle: {},
          'data': g.data,
          'type': g.type,
          'color': g.color,
          'smooth': true,
          'yAxisIndex': 0,
        });
        legend.add(g.name);
        data.addAll(g.data);
      }
    }

    final temperatureMaxMin = getMaxMin(data);

    final minTemperature = temperatureMaxMin['minTemperature'];
    final maxTemperature = temperatureMaxMin['maxTemperature'];

    if (outside?.isShow ?? false) {
      series2.add({
        'name': outside.name,
        //areaStyle: {},
        'data': outside.data,
        'type': outside.type,
        'color': outside.color,
        'smooth': true,
        'yAxisIndex': 1,
      });
      data2.addAll(outside.data);
    }

    final temperatureMaxMin2 = getMaxMin(data2);

    final minTemperature2 = temperatureMaxMin2['minTemperature'];
    final maxTemperature2 = temperatureMaxMin2['maxTemperature'];

    final Map<String, dynamic> option = {
      'legend': {
        'data': legend,
      },
      'grid': {
        'containLabel': true,
        'left': '10',
        'bottom': '40',
        'right': '10',
      },
      'tooltip': {
        'trigger': 'axis',
      },
      'xAxis': [
        {
          'type': 'category',
          'axisTick': 1,
          'axisLabel': {
            'rotate': 90,
            'fontSize': 10,
          },
          'data': xAxisData,
        },
      ],
      'yAxis': [
        {
          'name': 'Temperature (\u2103)',
          'type': 'value',
          'position': 'left',
          'min': maxTemperature,
          'max': minTemperature,
        },
        {
          'name': 'OUTSIDE',
          'type': 'value',
          'position': 'right',
          'min': maxTemperature2 ?? 0,
          'max': minTemperature2 ?? 1,
          'splitLine': {
            'show': false,
          },
        },
      ],
      'dataZoom': [
        {'start': 0, 'type': "inside"},
        {'start': 80}
      ],
      'series': [
        ...series,
        ...series2,
      ],
    };

    final optionToString = jsonEncode(option);
    return optionToString;
  }
}
