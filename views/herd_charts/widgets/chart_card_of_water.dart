import 'dart:convert';

import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/cow_single/domain/functions/function.dart';
import 'package:cattle_scan/views/herd_charts/models/herd_charts_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

import '../models/herd_charts_model_ui.dart';

class ChartCardOfWater extends StatelessWidget {
  const ChartCardOfWater({
    Key key,
    this.herdChartsModelUI,
  }) : super(key: key);

  final HerdChartsModelUI herdChartsModelUI;

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      height: isPortrait ? 300 : 400,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
    final isLactation = herdChartsModelUI?.water?.subGroup == SubGroupOfCharts.lactations;
    final isDay = herdChartsModelUI?.water?.timeInterval == TimeInterval.day;

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
        xAxisData = herdChartsModelUI?.water?.lactations?.lactationsDays?.day;
        outside = herdChartsModelUI?.water?.lactations?.lactationsDays?.outside;
        currentGraphics = [
          herdChartsModelUI?.water?.lactations?.lactationsDays?.bred,
          herdChartsModelUI?.water?.lactations?.lactationsDays?.dry,
          herdChartsModelUI?.water?.lactations?.lactationsDays?.fresh,
          herdChartsModelUI?.water?.lactations?.lactationsDays?.noBred,
          herdChartsModelUI?.water?.lactations?.lactationsDays?.okOpen,
          herdChartsModelUI?.water?.lactations?.lactationsDays?.preg,
          herdChartsModelUI?.water?.lactations?.lactationsDays?.undefined,
          herdChartsModelUI?.water?.lactations?.lactationsDays?.total,
        ];
      } else {
        xAxisData = herdChartsModelUI?.water?.lactations?.lactationsHours?.hour;
        outside = herdChartsModelUI?.water?.lactations?.lactationsHours?.outside;
        currentGraphics = [
          herdChartsModelUI?.water?.lactations?.lactationsHours?.bred,
          herdChartsModelUI?.water?.lactations?.lactationsHours?.dry,
          herdChartsModelUI?.water?.lactations?.lactationsHours?.fresh,
          herdChartsModelUI?.water?.lactations?.lactationsHours?.noBred,
          herdChartsModelUI?.water?.lactations?.lactationsHours?.okOpen,
          herdChartsModelUI?.water?.lactations?.lactationsHours?.preg,
          herdChartsModelUI?.water?.lactations?.lactationsHours?.undefined,
          herdChartsModelUI?.water?.lactations?.lactationsHours?.total,
        ];
      }
    } else {
      if (isDay) {
        xAxisData = herdChartsModelUI?.water?.groups?.groupsDays?.day;
        outside = herdChartsModelUI?.water?.groups?.groupsDays?.outside;
        currentGraphics = [
          herdChartsModelUI?.water?.groups?.groupsDays?.g1,
          herdChartsModelUI?.water?.groups?.groupsDays?.g1,
          herdChartsModelUI?.water?.groups?.groupsDays?.g2,
          herdChartsModelUI?.water?.groups?.groupsDays?.g3,
          herdChartsModelUI?.water?.groups?.groupsDays?.g4,
          herdChartsModelUI?.water?.groups?.groupsDays?.g5,
          herdChartsModelUI?.water?.groups?.groupsDays?.undefined,
          herdChartsModelUI?.water?.groups?.groupsDays?.total,
        ];
      } else {
        xAxisData = herdChartsModelUI?.water?.groups?.groupsHours?.hour;
        outside = herdChartsModelUI?.water?.groups?.groupsHours?.outside;
        currentGraphics = [
          herdChartsModelUI?.water?.groups?.groupsHours?.g1,
          herdChartsModelUI?.water?.groups?.groupsHours?.g1,
          herdChartsModelUI?.water?.groups?.groupsHours?.g2,
          herdChartsModelUI?.water?.groups?.groupsHours?.g3,
          herdChartsModelUI?.water?.groups?.groupsHours?.g4,
          herdChartsModelUI?.water?.groups?.groupsHours?.g5,
          herdChartsModelUI?.water?.groups?.groupsHours?.undefined,
          herdChartsModelUI?.water?.groups?.groupsHours?.total,
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
        'left': '0%',
        'bottom': '40',
        'right': '10',
      },
      'tooltip': {'trigger': 'axis'},
      'xAxis': {
        'axisTick': 0,
        'axisLabel': {
          'rotate': 90,
          'fontSize': 10,
        },
        'data': xAxisData,
      },
      'yAxis': [
        {
          'name': 'Liters',
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
