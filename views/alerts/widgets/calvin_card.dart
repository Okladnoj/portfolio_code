import 'dart:convert';

import 'package:cattle_scan/components/buttons/ink_custom_button.dart';
import 'package:cattle_scan/settings/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:intl/intl.dart';

import '../models/alert_model_ui.dart';

class CalvinCard extends StatelessWidget {
  const CalvinCard({
    Key key,
    @required this.alertModelUI,
    @required this.onTap,
    @required this.onCreateEvent,
  }) : super(key: key);

  final AlertModelUI alertModelUI;
  final void Function() onTap;
  final void Function() onCreateEvent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: DesignStile.buttonDecoration(
        colorBorder: DesignStile.primary,
      ),
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          final orientation = MediaQuery.of(context).orientation;
          return Column(
            children: [
              Row(
                children: [
                  buildInkCustomButton(onTap, 'Cow ${alertModelUI.cowId * DesignStile.maskCode}'),
                  const SizedBox(width: 15),
                  buildInkCustomButton(onCreateEvent, 'Press if calved'),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Echarts(
                  key: ValueKey(orientation),
                  captureHorizontalGestures: true,
                  option: option(alertModelUI?.listAlertModelUI),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildInkCustomButton(void Function() onTap, String text) {
    return Expanded(
      child: InkCustomButton(
        height: 35,
        onTap: onTap,
        child: Container(
          alignment: const Alignment(0, 0),
          decoration: DesignStile.buttonDecoration(
            colorBoxShadow: DesignStile.red,
            color: DesignStile.primary,
            colorBorder: DesignStile.red,
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: DesignStile.textStyleCustom(
              fontSize: 16,
              color: DesignStile.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  String option(List<AlertModelUI> listAlertModelUI) {
    final Map<String, dynamic> option = {
      'backgroundColor': '#ffffff',
      'legend': {
        'data': ['Calvin']
      },
      'grid': {
        'containLabel': true,
        'left': '0%',
        'bottom': '0',
        'right': '0',
        'top': '12',
      },
      'tooltip': [
        {
          'trigger': 'axis',
          'axisPointer': {
            'type': 'shadow',
          },
          'showContent': true,
          'formatter': 'Message:<br />{b1}',
          'extraCssText': "width:120px; white-space:pre-wrap;",
          'textStyle': {
            'fontSize': 12,
          },
        }
      ],
      'xAxis': {
        'axisLine': {
          'lineStyle': {
            'color': '#ec3135',
            'width': 0.5,
          }
        },
        'axisLabel': {
          'interval': 0,
          'rotate': 0,
          'fontSize': 10,
        },
        'data': listAlertModelUI?.map((e) => _parsData(e.created))?.toList() ?? [],
      },
      'yAxis': {
        'type': 'value',
        'min': 50,
        'max': 100,
        'splitNumber': 1,
        'splitLine': {
          'show': true,
          'lineStyle': {
            'color': '#999999',
            'width': 0.5,
          },
        },
        'axisLine': {
          'lineStyle': {
            'color': '#ec3135',
            'width': 0.5,
          },
        },
        'axisLabel': {
          'formatter': '{value}%',
          'rotate': 90,
          'fontSize': 10,
        },
      },
      'series': [
        {
          // 'name': 'Calvin',
          'data': listAlertModelUI?.map((e) => {'value': e.value, 'name': '${e.value}%'})?.toList() ?? [],
          'type': 'bar',
          'color': 'blue',

          'label': {
            'show': true,
            'position': 'inside',
            'formatter': '{c}%',
          }
        },
        {
          // 'name': 'Calvin',
          'data': listAlertModelUI?.map((e) => {'value': 0, 'name': e.message})?.toList() ?? [],
          'type': 'line',
          'color': 'white',
        },
      ]
    };
    final optionToString = jsonEncode(option);
    return optionToString;
  }

  String _parsData(String created) {
    final date = DateTime.tryParse(created);
    final f = DateFormat('hh:mm a \n d-MMM');
    return f.format(date);
  }
}
