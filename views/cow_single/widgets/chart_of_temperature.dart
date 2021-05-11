import 'dart:convert';

import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/cow_single/models/temperature_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

import '../models/cow_single_ui.dart';

class ChartOfTemperature extends StatelessWidget {
  const ChartOfTemperature({
    Key key,
    @required CowSingleModelUI cowSingleModelUI,
  })  : _cowSingleModelUI = cowSingleModelUI,
        super(key: key);

  final CowSingleModelUI _cowSingleModelUI;
  bool get isToday => _cowSingleModelUI?.selectedFilter == StateTimeInterval.today;

  @override
  Widget build(BuildContext context) {
    final temperatureChar = isToday
        ? _cowSingleModelUI?.temperatureChartOfDay //
        : _cowSingleModelUI?.temperatureChartOfWeek;
    final isLoad = temperatureChar == null;
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        if (isLoad)
          Container()
        else
          temperatureChar?.temperatureChartTitleDate != null
              ? Text(
                  'Temperature \n (${temperatureChar?.temperatureChartTitleDate ?? '...'})',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : const Text(
                  'No Temperature',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        const SizedBox(height: 20.0),
        if (isLoad)
          Container(
            height: 200,
            decoration: DesignStile.buttonDecoration(borderRadius: 0, offset: const Offset(0, 0)),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
              ),
            ),
          )
        else
          (temperatureChar?.temperatureChart?.length ?? 0) > 0
              // ignore: sized_box_for_whitespace
              ? LayoutBuilder(builder: (context, boxConstraints) {
                  final orientation = MediaQuery.of(context).orientation;
                  return SizedBox(
                    height: 400,
                    child: Echarts(
                      key: ValueKey(orientation),
                      captureHorizontalGestures: true,
                      option: option(temperatureChar),
                    ),
                  );
                })
              : Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: const BoxDecoration(color: Colors.yellow),
                  child: const Text(
                    'No data at the moment',
                    textAlign: TextAlign.center,
                  ),
                ),
      ],
    );
  }

  String option(TemperatureChart temperatureChar) {
    final Map<String, dynamic> option = {
      'legend': {
        'data': [
          'Max temp',
          'Temp',
          'Min temp',
        ]
      },
      'grid': {
        'containLabel': true,
        'left': '0',
        'bottom': '50',
        'right': '10',
      },
      'tooltip': {'trigger': 'axis'},
      'dataZoom': [
        {'start': 0, 'type': "inside"},
        {'start': 80}
      ],
      'xAxis': {
        'axisTick': 0,
        'axisLabel': {
          'rotate': 90,
          'fontSize': 10,
        },
        'data': temperatureChar?.temperatureChartLabels,
      },
      'yAxis': {
        'type': 'value',
        'min': temperatureChar.maxTemperature,
        'max': temperatureChar.minTemperature,
      },
      'visualMap': {
        'top': 0,
        'right': -100,
        'pieces': [
          {
            'gt': 0,
            'lte': 40.5,
            'color': '#3949ab',
          },
          {
            'gt': 40.5,
            'lte': 41.0,
            'color': '#EC7C31',
          },
          {
            'gt': 41.0,
            'color': '#FF0000',
          }
        ],
        'outOfRange': {
          'color': '#000000',
        }
      },
      'series': [
        {
          'name': 'Temp',
          //areaStyle: {},
          'data': temperatureChar?.temperatureChart?.map((e) => e?.toStringAsFixed(2))?.toList(),
          'type': 'line',
          'color': '#3949ab',
        },
      ]
    };
    final optionToString = jsonEncode(option);
    return optionToString;
  }
}
