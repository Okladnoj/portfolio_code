import 'dart:convert';

import 'package:cattle_scan/settings/constants.dart';
import 'package:cattle_scan/views/cow_single/models/water_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

import '../models/cow_single_ui.dart';

class ChartOfWater extends StatelessWidget {
  const ChartOfWater({
    Key key,
    @required CowSingleModelUI cowSingleModelUI,
  })  : _cowSingleModelUI = cowSingleModelUI,
        super(key: key);

  final CowSingleModelUI _cowSingleModelUI;
  bool get isToday => _cowSingleModelUI?.selectedFilter == StateTimeInterval.today;

  @override
  Widget build(BuildContext context) {
    final _waterChartModel =
        isToday ? _cowSingleModelUI?.waterChartModelOfDay : _cowSingleModelUI?.waterChartModelOfWeek;
    String totalIntakes;
    try {
      totalIntakes = _cowSingleModelUI?.waterIntakesData[_cowSingleModelUI?.selectedFilter];
    } catch (e) {
      print(e);
    }
    final isLoad = _waterChartModel == null;
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        if (isLoad)
          Container()
        else
          Text(
            totalIntakes != null
                ? 'Intakes total = ${totalIntakes ?? '...'} litres \n (${_waterChartModel?.waterChartTitleDate ?? '...'})'
                : 'No Intakes',
            textAlign: TextAlign.center,
            style: const TextStyle(
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
          (_waterChartModel?.waterChart?.length ?? 0) > 0
              // ignore: sized_box_for_whitespace
              ? LayoutBuilder(builder: (context, boxConstraints) {
                  final orientation = MediaQuery.of(context).orientation;
                  return SizedBox(
                    height: 400,
                    child: Echarts(
                      key: ValueKey(orientation),
                      captureHorizontalGestures: true,
                      option: option(_waterChartModel),
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

  String option(WaterChartModel _waterChartModel) {
    final Map<String, dynamic> option = {
      'legend': {
        'data': ['Water intake', isToday ? '' : 'Total per day']
      },
      'grid': {
        'containLabel': true,
        'left': '0%',
        'bottom': '50',
        'right': '10',
      },
      'tooltip': {'trigger': 'axis'},
      'dataZoom': [
        {'start': 0, 'type': "inside"},
        {'start': 80}
      ],
      'xAxis': {
        'axisLabel': {
          'rotate': 90,
          'fontSize': 10,
        },
        'data': _waterChartModel.waterChartLabels,
      },
      'yAxis': [
        {
          'type': 'value',
          'position': 'left',
        },
        {
          'type': 'value',
          'position': 'right',
        },
      ],
      'series': [
        {
          'name': 'Water intake',
          'data': _waterChartModel.waterChart?.map((e) => e?.toStringAsFixed(2))?.toList(),
          'type': 'bar',
          'color': 'blue',
          'yAxisIndex': 0,
        },
        {
          'name': 'Total per day',
          'data': _waterChartModel.waterChartNormal?.map((e) => e?.toStringAsFixed(2))?.toList(),
          'type': 'line',
          'symbol': 'none',
          'color': 'red',
          'yAxisIndex': 1,
        },
      ]
    };
    final optionToString = jsonEncode(option);
    return optionToString;
  }
}
